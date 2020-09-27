defmodule Haberdash.Transactions.OrderWorker do
  use GenServer
  use Haberdash.MapHelpers
  alias Haberdash.Transactions.Orders
  alias Haberdash.Transactions
  alias Haberdash.Transactions.PersistOrderState
  require Logger
  @name :orders

  @doc """
  Stores all incomplete orders in a map with randomly generated ids.
  """
  defp via_tuple(id) do
    {:via, :gproc, {:n, :l, {@name, id}}}
  end

  @spec create_order(pid :: pid(), order :: map()) :: {:ok, Ecto.UUID.t(), map()}
  def create_order(pid, order) do
    GenServer.call(pid, {:create_order, order})
  end

  @spec append_order(pid :: pid(), id :: Ecto.UUID.t(), order :: map()) :: any
  def append_order(pid, id, order) do
    GenServer.call(pid, {:append_order, id, order})
  end

  def show_order(pid, id) do
    GenServer.call(pid, {:show_order, id})
  end

  def modify_order(pid, id, order), do: GenServer.call(pid, {:modify_order, id, order})

  def delete_order(pid, id) do
    GenServer.cast(pid, {:delete_order, id})
  end

  def cast_map(map), do: stringify_map(map)

  # SERVER STUFF

  def start_link(args) do
    id = Keyword.fetch!(args, :id)
    Logger.info("Starting order queue #{id} for #{__MODULE__}")
    GenServer.start_link(__MODULE__, [id: id], name: via_tuple(id))
  end

  @impl true
  def init(args) do
    id = Keyword.fetch!(args, :id)
    Process.flag(:trap_exit, true)
    state =
      case PersistOrderState.exists?(id) do
        true ->
          {:ok, state} = PersistOrderState.load(id)
          state
        false ->
          IO.puts("doesn't exist creating right now")
          PersistOrderState.create(id, %{"id" => id})
          %{"id" => id}
      end


      {:ok, state}


  end

  @impl true
  def handle_call({:create_order, params}, _from, state) do
    id = Ecto.UUID.generate()
    order = stringify_map(params)
    order = Orders.create_order_list(order) |> Map.put("id", id)
    state = Map.put(state, id, Map.put(order, "id", id))

    {:reply, {:ok, order}, state}
  end

  @impl true
  def handle_call({:append_order, id, params}, _from, state) do
    new_orders = stringify_map(params)
    Logger.info("id: #{inspect(state["id"])}")
    updated_orders = Orders.append_order_list(state[id], new_orders)
    {:reply, {:ok, updated_orders}, state}
  end

  def handle_call({:modify_order, id, params}, _from, state) do
    string_params = stringify_map(params)
    updated_orders = Orders.modify_order_list(state[id], string_params)
    {:reply, {:ok, updated_orders}, state}
  end

  def handle_call({:show_order, id}, _from, state) do
    case Map.fetch(state, id) do
      {:ok, order} -> {:reply, {:ok, order}, state}
      :error -> {:reply, {:error, :not_found}, state}
    end
  end

  @impl true
  def handle_cast({:delete_order, id}, state) do
    state = Map.delete(state, id)
    {:noreply, state}
  end

  def hande_call({:submit_order, temp_id, attrs}, _from, state) do
    with %Orders{} = order <- Map.get(state, temp_id, nil),
         {:ok, order} <- Transactions.create_orders(order, attrs),
         state <- Map.delete(state, temp_id) do
      {:reply, {:ok, order}, state}
    else
      nil ->
        {:error, :not_found}

      {:error, changeset} ->
        {:reply, {:error, changeset}, state}
    end
  end

  @impl true
  def terminate(_reason, state) do
    Logger.info("terminating order server: #{state["id"]}")
    IO.inspect state

    PersistOrderState.dump(Map.get(state, "id"), state)
  end


end
