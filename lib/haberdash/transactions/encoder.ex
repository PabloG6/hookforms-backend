defimpl Poison.Encoder, for: Haberdash.Transactions.OrderItems do
  def encode(%{__struct__: _} = struct, opts) do
    map = struct |> Map.from_struct
          |> Map.drop([:__struct__, :__meta__])
    Poison.Encoder.Map.encode(map, opts)
  end
end
