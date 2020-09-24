defmodule Haberdash.Transactions.PersistCheckoutState do
  use GenServer
  require Logger


  # SERVER STUFF
  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    folder_name = Application.fetch_env!(:haberdash, :folder_name)
    path = Path.join([File.cwd!, "tmp", "checkout", folder_name])
    File.mkdir_p(path)
    Logger.info("#{__MODULE__} path: #{path}")
    Process.flag(:trap_exit, true)
    {:ok, path}
  end


end
