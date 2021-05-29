defimpl Plug.Exception, for: Haberdash.Exception.InventoryNotFound do
  def status(_), do: 404

end
