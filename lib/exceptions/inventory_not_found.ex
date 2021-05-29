defmodule Haberdash.Exception.InventoryNotFound do
  defexception [:message, plug_status: 404]

  @impl true
  def exception(id) do
    IO.inspect id
    %__MODULE__{message: "#{id} not found in inventory.", plug_status: 404}
  end
end
