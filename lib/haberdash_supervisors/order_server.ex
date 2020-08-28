defmodule Haberdash.Workers.Orders do
  alias Haberdash.Transactions.Orders
  alias Haberdash.Transactions
  require Logger
  use GenServer
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

  @impl true
  def handle_call({:create_order, order}, _from, state) do
    temp_id = Ecto.UUID.generate()
    order = %{order | id: temp_id}
    state = Map.put(state, temp_id, order)
    {:reply, {:ok, temp_id}, state}
  end

  @impl true
  def handle_call({:update_order, temp_id,order}, _from, state) do
    state = Map.put(state, temp_id, order)
    {:reply, :ok, state}
  end


  @impl true
  def handle_cast({:delete_order, temp_id}, state) do
    state = Map.delete(state, temp_id)
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
