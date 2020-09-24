defmodule Haberdash.Transactions.PersistOrderState do
  @moduledoc """
  persistent binary marshalling and storage for
  """


  use GenServer
  require Logger
  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    folder_name = Application.fetch_env!(:haberdash, :folder_name)
    path = Path.join([File.cwd!, "tmp", "orders", folder_name])
    Logger.info("initializing #{path}")
    File.mkdir_p(path)
    {:ok, path}
  end

  @doc """
  creates a file to dump data to. Silently fails
  iex> create(id)
  :ok
  """

  def create(id, state) do
    GenServer.cast(__MODULE__, {:create, id, state})
  end

  def exists?(id) do
    GenServer.call(__MODULE__, {:exists, id})
  end

  @doc """
  loads data from a dumped file.
  iex> load(id)
  {:ok, state}
  """
  def load(id) do
    GenServer.call(__MODULE__, {:load, id})
  end

  @doc """
  dumps state of a failed genserver to file. Silently fails
  iex> dump(id, state)
  :ok
  """
  def dump(id, state) do
    GenServer.cast(__MODULE__, {:dump, id, state})
  end

  def handle_cast({:dump, id, state}, root) do
    path = Path.join([root, id])

    case File.touch(path) do
      :ok ->
        File.write(path, :erlang.term_to_binary(state))
        {:noreply, root}
    end
  end

  def handle_cast({:create, id, state}, root) do
    case File.touch(Path.join(root, id)) do
      :ok ->
        File.write(Path.join(root, id), :erlang.term_to_binary(state))
        {:noreply, root}
        _ -> {:noreply, root}
    end
  end

  def handle_call({:load, id}, _, root) do
    path = Path.join(root, id)

    case File.read(path) do
      {:ok, binary} ->
        {:reply, {:ok, :erlang.binary_to_term(binary)}, root}

      err ->
        {:reply, err, root}
    end
  end

  def handle_call({:exists, id}, _, root), do: {:reply, File.exists?(Path.join(root, id)), root}
end
