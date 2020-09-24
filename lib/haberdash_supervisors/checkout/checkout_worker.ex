defmodule Haberdash.Transactions.CheckoutWorker do
  use GenServer
  require Logger

  def start_link(args) do
    id = Keyword.fetch!(args, :id)
    Logger.info("Starting checkout queue #{id} for #{__MODULE__}")
    GenServer.start_link(__MODULE__, [id: id], name: via_tuple(id))

  end

  defp via_tuple(id), do: {:via, :gproc, {:n, :l, id}}

  def init(args) do
    id = Keyword.fetch!(args, :id)
    Process.flag(:trap_exit, true)
    {:ok, Map.new}
  end


  @doc """
  creates a checkout instance that stores the current order and the checkout
  state of the user
  iex>
  """
  def create_checkout(pid, order) do
    GenServer.call(pid, {:create_checkout, order})
  end

  def handle_call({:create_checkout, order}, _from, state) do
    {:reply, {:ok}, state}
  end
end
