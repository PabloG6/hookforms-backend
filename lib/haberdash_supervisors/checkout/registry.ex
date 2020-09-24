defmodule Haberdash.Transactions.CheckoutRegistry do
  use GenServer
  require Logger
  @name :checkout
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def via_tuple(id) do
    {:via, :gproc, {:n, :l, {@name, id}}}
  end

  def init(_) do
    {:ok, Map.new}
  end

  @spec whereis_name(id :: binary()) :: {:ok, pid()} | {:error, :undefined}
  def whereis_name(id) do
    # Logger.info("#{__MODULE__} searching for franchise")
    # GenServer.call(__MODULE__, {:whereis_name, id})
    with pid when is_pid(pid) <- :gproc.where({:n, :l, {@name, id}}) do
      {:ok, pid}
    else
      :undefined ->
        {:error, :undefined}
    end
  end
end
