defmodule Haberdash.Transactions.OrderSupervisor do
  use DynamicSupervisor
  alias Haberdash.Transactions
  require Logger

  def start_link(args) do
    name = Keyword.get(args, :name)
    Logger.info("#{__MODULE__} start_link")
    Logger.info(inspect(args))
    DynamicSupervisor.start_link(__MODULE__, args, name: name)
  end

  @impl true
  def init(_) do
    Logger.info("initializing  #{__MODULE__}")
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_child(id) do
    Logger.info("#{__MODULE__} starting child")
    Logger.info(inspect(self()))

    DynamicSupervisor.start_child(__MODULE__, %{
      id: Transactions.OrderWorker,
      start: {Haberdash.Transactions.OrderWorker, :start_link, [[id: id]]},
      restart: :transient
    })
  end

  @spec terminate_child(binary) :: :ok | {:error, :not_found}
  def terminate_child(id) do
    case Haberdash.Transactions.OrderRegistry.whereis_name(id) do
      {:ok, pid} ->
        DynamicSupervisor.terminate_child(__MODULE__, pid)

      error ->
        error
    end
  end
end
