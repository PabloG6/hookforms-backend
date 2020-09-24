defmodule Haberdash.Transactions.CheckoutSupervisor do
  use DynamicSupervisor
  alias Haberdash.Transactions
  require Logger

  def start_link(args) do
    Logger.info("#{__MODULE__} start_link")
    DynamicSupervisor.start_link(__MODULE__, args, name: __MODULE__)

  end


  @impl true
  def init(_) do
    Logger.info("initializing #{__MODULE__}")
    DynamicSupervisor.init(strategy: :one_for_one)
  end


  def start_child(id) do
    DynamicSupervisor.start_child(__MODULE__, %{
      id: Transactions.CheckoutWorker,
      start: {Haberdash.Transactions.CheckoutWorker, :start_link, [[id: id]]},
      restart: :transient

    })
  end


  def terminate_child(id) do
    case Haberdash.Transactions.CheckoutRegistry.whereis_name(id) do
      {:ok, pid} ->
        DynamicSupervisor.terminate_child(__MODULE__, pid)

    end
  end
end
