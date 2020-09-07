defmodule Haberdash.Exception.InventoryNotFound do
  defexception [:message, plug_status: 404]

  @impl true
  def exception(id) do
    %Haberdash.Exception.InventoryNotFound{message: "#{id} not found in inventory."}
  end


end
