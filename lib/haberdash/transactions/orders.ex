defmodule Haberdash.DeliveryType do
  use EctoEnum, type: :delivery_type, enums: [:pickup, :dropoff]

end
defmodule Haberdash.Transactions.Orders do
  use Ecto.Schema
  import Ecto.Changeset
  alias Haberdash.{Business, Inventory, Navigation, Transactions}
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "orders" do
    field :customer_id, :binary
    embeds_one :drop_off_address, Navigation.Location
    field :delivery_type, Haberdash.DeliveryType, default: :pickup
    belongs_to :franchise, Business.Franchise
    embeds_many :items, Transactions.Item

    timestamps()
  end



  @doc false
  def changeset(orders, attrs) do
    orders
    |> cast(attrs, [:customer_id, :drop_off_location, :drop_off_address, :franchise_id, :items])
    |> cast_embed(:items)
    |> validate_required([:drop_off_location, :drop_off_address, :franchise_id])
  end
  def create_changeset(orders, attrs) do
    orders
    |> cast(attrs, [:franchise_id, :id])
    |>cast_embed(:items)
    |> validate_required([:franchise_id, :items, :id])
  end

  def update_changeset(orders, attrs) do
    items = Map.get(attrs, :items, []) || Map.get(attrs, "items", [])
    orders
    |> cast(attrs, [:franchise_id])
    |> put_embed(:items, items)
    |> validate_required([:franchise_id, :items])
  end




end

defmodule Haberdash.Transactions.Item do
  use Ecto.Schema
  import Ecto.Changeset
  alias Haberdash.{Transactions, Inventory}
  @primary_key {:id, :binary_id, autogenerate: true}
  embedded_schema do
    field :name, :string
    field :product_id, :string
    field :description, :string
    field :price, :integer
    embeds_many :accessories, Transactions.Accessories
  end


 def changeset(item, attrs) do
    product_id = Map.get(attrs, "product_id", nil) || Map.get(attrs, :product_id, nil)
    accessories = Map.get(attrs, "accessories", []) || Map.get(attrs, :accessories, [])
    product_entry = Inventory.get_products!(product_id)
    product_items = %{name: product_entry.name, product_id: product_id, description: product_entry.description, price: product_entry.price}
    item
    |> cast(product_items, [:name, :product_id, :description, :price])
    |> cast_embed(:accessories, accessories)
  end



end



defmodule Haberdash.Transactions.Accessories do
  use Ecto.Schema
  import Ecto.Changeset
  alias Haberdash.{Transactions, Inventory}
  @primary_key {:id, :binary_id, autogenerate: true}
  embedded_schema do
    field :name, :string
    field :accessories_id, :string
    field :description, :string
    field :price, :integer
  end

  def changeset(accessories, attrs) do
    accessories_id = Map.get(attrs, "accessories_id", nil) || Map.get(attrs, :accessories_id, nil)
    accessories_entry = Inventory.get_accessories!(accessories_id)
    accessories_item = %{name: accessories_entry.name, description: accessories_entry.description, price: accessories_entry.price, accessories_id: accessories_entry.id}

    accessories
    |> cast(accessories_item, [:name, :accessories_id, :description, :price])

  end
end
