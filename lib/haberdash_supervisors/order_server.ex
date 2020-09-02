defmodule Haberdash.Transactions.OrdersWorker do
  use GenServer

  alias Haberdash.Transactions.Orders
  alias Haberdash.Transactions

  require Logger
  @doc """
  Stores all incomplete orders in a map with randomly generated ids.
  """

  def start_link(args) do
    id = Keyword.fetch!(args, :id)
    Logger.info("Starting order queue #{id} for #{__MODULE__}")
    GenServer.start_link(__MODULE__, [], name: via_tuple(id))
  end

  @impl true
  def init(_) do
    {:ok, Map.new}
  end

  defp via_tuple(id) do
    {:via, :gproc, {:n, :l, id}}
  end


  @spec create_order(pid::pid(), order::map()) :: {:ok, Ecto.UUID.t(), map()}
  def create_order(pid, order) do

    GenServer.call(pid, {:create_order, order})
  end

  @spec update_order(pid:: pid(), id::Ecto.UUID.t(), order:: map()) :: any
  def update_order(pid, id, order) do
    GenServer.call(pid, {:update_order, id, order})
  end

  def delete_order(pid, id) do
    GenServer.cast(pid, {:delete_order, id})
  end
  # SERVER STUFF
  @impl true
  def handle_call({:create_order, params}, _from, state) do

    id = Ecto.UUID.generate()
    Logger.info("handle_call, params: #{inspect(params)}")
    # order = Kernel.struct(Orders, params)
    # items = Map.get(params, "items") || Map.get(params, :items)
    # item_list = Orders.create_order_list(items)
    # Logger.info("handle_call order_list: #{inspect(item_list)}")
    # order = %{order | id: id, items: item_list}
    # state = Map.put(state, id, order)
    # Logger.info("current state #{inspect(state)}")

    order = Maptu.struct!(Orders, params)
    order = Orders.create_order_list(order)
    {:reply, {:ok, order}, state}
  end

  @impl true
  def handle_call({:update_order, id, order}, _from, state) do
    state = Map.put(state, id, Kernel.struct(Orders, order))
    {:reply, :ok, state}
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
end
