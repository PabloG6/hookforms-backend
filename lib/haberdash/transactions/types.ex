defmodule Haberdash.Transactions.DeliveryType do
  use EctoEnum, type: :delivery_type, enums: [:pickup, :dropoff]

end

defmodule Haberdash.Transactions.ItemType do
  use EctoEnum, type: :item_type, enums: [:accessories, :products]
end
