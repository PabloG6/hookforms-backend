defmodule Haberdash.Listener.Franchise do
  use GenServer
  alias Haberdash.Business
  alias Haberdash.Transactions
  import Poison
  require Logger
  @channel "franchise_created"
  @impl true
  def init(_) do
    {:ok, pid} =
      Application.get_env(:haberdash, Haberdash.Repo)
      |> Postgrex.Notifications.start_link()

    {:ok, ref} = Postgrex.Notifications.listen(pid, @channel)
    franchise_list = Business.list_franchises()
    for franchise <- franchise_list, do: Transactions.OrderSupervisor.start_child(franchise.id)
    {:ok, {ref, pid, @channel, franchise_list}}
  end

  def start_link(opts) do
    Logger.info("starting #{__MODULE__}")
    GenServer.start_link(__MODULE__, opts)
  end

  @impl true
  def handle_info(info, {_ref, _pid, channel, _data} = state) do
    {:notification, _notification_pid, _listen_ref, _channel, raw_payload} = info
    Logger.info("#{__MODULE__} database has been modified from the #{channel}")

    case raw_payload |> decode! |> handle_payload do
      {:ok, _pid} ->
        {:noreply, state}

      error ->
        Logger.info("#{__MODULE__} and unknown error has occured")
        IO.inspect(error)
        error
    end

    {:noreply, state}
  end

  def handle_payload(%{"type" => "INSERT", "id" => id}) do
    Haberdash.Transactions.OrderSupervisor.start_child(id)
  end

  def handle_payload(%{"type" => "DELETE", "id" => id}) do
    Haberdash.Transactions.OrderSupervisor.terminate_child(id)
  end
end
