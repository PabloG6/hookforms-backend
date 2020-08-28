defmodule Haberdash.Supervisor.Orders do
  use DynamicSupervisor
  alias Haberdash.Workers
  require Logger
  def start_link(args) do
    name = Keyword.get(args, :name)
    Logger.info("#{__MODULE__} start_link")
    Logger.info inspect(args)
    DynamicSupervisor.start_link(__MODULE__, args, name: name)
  end

  @impl true
  def init(_) do
    Logger.info("initializing  #{__MODULE__}")
    DynamicSupervisor.init(strategy: :one_for_one)

  end

  def start_child(id) do
    Logger.info("#{__MODULE__} starting child")
    Logger.info inspect(self())
    Logger.info("#{__MODULE__} starting an order supervisor")
    DynamicSupervisor.start_child(__MODULE__, %{id: Workers.Orders, start: {Haberdash.Workers.Orders, :start_link, [[id: id]]}, restart: :transient})
  end

  def terminate_child(id) do
    case Haberdash.Registry.Orders.whereis_name(id) do
      {:ok, pid} ->
        DynamicSupervisor.terminate_child(__MODULE__, pid)

      error  -> error
    end
  end


end
