defmodule Haberdash.Transactions.OrderRegistry do
  use GenServer
  require Logger

  @doc """
  a wrapper for gproc
  """
  def start_link(opts) do
    # Register the order registry
    Logger.info("starting #{__MODULE__}")
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @spec whereis_name(id :: binary()) :: {:ok, pid()} | {:error, :undefined}
  def whereis_name(id) do
    # Logger.info("#{__MODULE__} searching for franchise")
    # GenServer.call(__MODULE__, {:whereis_name, id})
    with pid when is_pid(pid) <- :gproc.where({:n, :l, id}) do
      {:ok, pid}
    else
      :undefined ->
        {:error, :undefined}
    end
  end

  def via_tuple(id) do
    {:via, :gproc, {:n, :l, id}}
  end

  def register_name(franchise_id, pid) do
    Logger.info("#{__MODULE__} registering name")
    GenServer.cast(__MODULE__, {:register_name, franchise_id, pid})
  end

  def unregister_name(franchise_id) do
    GenServer.cast(__MODULE__, {:unregister_name, franchise_id})
  end

  def send(franchise_id, message) do
    case whereis_name(franchise_id) do
      {:error, :undefined} ->
        {:badarg, {franchise_id, message}}

      {:ok, pid} ->
        Kernel.send(pid, message)
        pid
    end
  end

  # Server work

  @impl true
  def init(_) do
    {:ok, Map.new()}
  end

  @impl true
  def handle_call({:whereis_name, franchise_id}, _from, state) do
    IO.inspect(state)
    IO.puts(franchise_id)

    case Map.get(state, franchise_id, nil) do
      nil ->
        {:reply, :undefined, state}

      pid ->
        {:reply, pid, state}
    end
  end

  @impl true
  def handle_call({:register_name, franchise_id, pid}, _from, state) do
    Logger.info("#{__MODULE__} registering franchise: #{franchise_id}")

    case Map.get(state, franchise_id) do
      nil ->
        {:reply, :yes, Map.put(state, franchise_id, pid)}

      _ ->
        {:reply, :no, state}
    end
  end

  @impl true
  def handle_cast({:unregister_name, franchise_id}, state) do
    {:noreply, Map.delete(state, franchise_id)}
  end
end
