defmodule Haberdash.Exception.InventoryNotFound do
  defexception [:message, plug_status: 404]

  @impl true
  def exception(opts) do
    %__MODULE__{message: Keyword.get(opts, :message, "The requested resource was not found."), plug_status: 404}
  end
end
