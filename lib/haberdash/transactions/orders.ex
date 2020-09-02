
defmodule Haberdash.Transactions.Orders do
  use Ecto.Schema
  import Ecto.Changeset
  require Logger
  alias Haberdash.{Business, Inventory, Navigation, Transactions}
  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Poison.Encoder, except: [:__struct__, :__meta__, :franchise]}
  @foreign_key_type :binary_id
  schema "orders" do
    embeds_one :drop_off_address, Navigation.Location
    field :delivery_type, Haberdash.Transactions.DeliveryType, default: :pickup
    belongs_to :franchise, Business.Franchise
    embeds_many :items, Transactions.OrderItems

    timestamps()

  end



  @doc false
  def changeset(orders, attrs) do
    orders
    |> cast(attrs, [:customer_id, :drop_off_address, :franchise_id, :items])
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

  @doc """
  creates a human readable list of items from inventory based on information in the database.
  """

  def create_order_list(%{items: items} = orders) when is_map(orders) do
    Logger.info("create order list items: #{inspect(items)}")
    %{orders | items: Enum.map(items, &find_item/1)}



  end

  defp find_item(item) do
    Logger.info "find item item #{inspect(item)}"
    struct = Maptu.struct!(Transactions.OrderItems, item)
    Logger.info "find_item struct #{inspect(struct)}"
    convert_item(struct)
  end
  defp convert_item(%{item_id: item_id, item_type: :products} = item) do
    try do
      product = Inventory.get_products!(item_id)
      map = (for {k, v} <- Map.from_struct(product), into: %{}, do: {Atom.to_string(k), v}) |> Map.drop(["accessories"])
      Logger.info("map when converted to string map #{inspect(map)}")
      Maptu.struct!(Haberdash.Transactions.OrderItems, map)
    rescue
      Ecto.NoResultsError ->
        %{item | message: "No accessory or product found that matches this item_id: #{item_id}"}
    end
  end

  defp convert_item(%{item_type: :accessories, item_id: item_id} = item) do
    try do
      product = Inventory.get_accessories!(item_id)
      map = Map.from_struct(product) |> Map.put(:item_id, item_id)
      Transactions.OrderItems |> Kernel.struct(map)
    rescue
      Ecto.NoResultsError ->
        %{item | message: "No accessory or product found that matches this item_id: #{item_id}"}
    end
  end

  # defp convert_item(%{item_type: item_type} = item) do
  #   %{item | message: "item_type doesn't match specified item type options #{Atom.to_string(item_type)}"}
  # end

end




defmodule Haberdash.Transactions.Accessories do
  use Ecto.Schema
  import Ecto.Changeset
  alias Haberdash.{Inventory}
  @derive {Poison.Encoder, except: [:__meta__]}
  @primary_key {:id, :binary_id, autogenerate: true}
  embedded_schema do
    field :name, :string
    field :item_id, :binary_id
    field :description, :string
    field :price, :integer
  end

  def changeset(accessories, attrs) do
    item_id = Map.get(attrs, "item_id", nil) || Map.get(attrs, :item_id, nil)
    accessories_entry = Inventory.get_accessories!(item_id)
    accessories_item = %{name: accessories_entry.name, description: accessories_entry.description, price: accessories_entry.price, accessories_id: accessories_entry.id}

    accessories
    |> cast(accessories_item, [:name, :item_id, :description, :price])

  end
end
