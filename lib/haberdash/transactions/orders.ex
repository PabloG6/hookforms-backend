defmodule Haberdash.Transactions.Orders do
  use Ecto.Schema
  use Haberdash.MapHelpers
  import Ecto.Changeset
  require Logger
  alias Haberdash.Exception
  alias Haberdash.{Business, Inventory, Navigation, Transactions, Assoc, Account}
  alias Haberdash.Repo
  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Poison.Encoder, except: [:__struct__, :__meta__, :franchise]}
  @foreign_key_type :binary_id
  schema "orders" do
    belongs_to :customer, Account.Customer
    field :formatted_address, :string
    embeds_one :coordinates, Navigation.Coordinates
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
    |> cast_embed(:items)
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

  def create_order_list(%{"items" => items} = orders) when is_map(orders) do
    orders = %{orders | "items" => Enum.map(items, &create_order/1)}
    Map.put(
      orders,
      "total",
      reduce(orders, 0, fn {k, v}, acc ->
        case {k, v} do
          {"price", v} -> v + acc
          _ -> acc
        end
      end)
    )
  end

  def create_order_list(_), do: raise Exception.IncorrectFormat

  @doc """
  adds new order(s) to an existing order.
  """
  def append_order_list(%{"items" => items} = orders, %{"items" => updated_items}) do
   orders = %{orders | "items" => items ++ Enum.map(updated_items, &create_order/1)}
   Map.put(
      orders,
      "total",
      reduce(orders, 0, fn {k, v}, acc ->
        case {k, v} do
          {"price", v} -> v + acc
          _ -> acc
        end
      end)
    )
  end

  def append_order_list(_, _), do: raise Exception.IncorrectFormat

  def modify_order_list(%{"items" => previous_orders} = orders, %{"items" => updated_orders}) do
    # iterate over the previous orders, compare them to the new orders and pass them to modify orders function
    orders = %{
      orders
      | "items" =>
          Enum.map(previous_orders, fn current_order ->
            modify_order(
              current_order,
              Enum.find(updated_orders, &(&1["id"] == current_order["id"]))
            )
          end)
    }

    Map.put(
      orders,
      "total",
      reduce(orders, 0, fn {k, v}, acc ->
        case {k, v} do
          {"price", v} -> v + acc
          _ -> acc
        end
      end)
    )
  end

  def modify_order_list(_, _), do: raise Exception.IncorrectFormat


  defp modify_order(%{"id" => id}, nil),
    do:
      raise(Exception.InventoryNotFound,
        message: "No order of id: #{id} found in this order instance"
      )

  defp modify_order(current_order, %{"accessories" => accessories}) do
    Map.put(current_order, "accessories", Enum.map(accessories, &create_order/1))
  end

  defp modify_order(_, _),
    do: raise(Exception.InventoryNotFound, message: "Malformed data sent to endpoint")

  def validate_accessories_length() do
  end

  # create order stuff

  defp create_order(%{"id" => "prod_" <> id, "accessories" => [_ | _] = accessories} = map)
       when is_map(map) do
    product = Inventory.get_products!(id)

    stringify_map(product)
    |> Map.put("accessories", Enum.map(accessories, fn acc -> create_order(id, acc) end))
  rescue
    Ecto.NoResultsError ->
      raise Exception.InventoryNotFound, id
  end

  defp create_order(%{"id" => "prod_" <> id} = map) when is_map(map) do
    Inventory.get_products!(id)
    |> stringify_map
    |> Map.merge(%{"id" => Ecto.UUID.generate(), "inventory_id" => "prod_" <> id})
  rescue
    Ecto.NoResultsError ->
      raise Exception.InventoryNotFound, id
  end

  defp create_order(%{"id" => "acc_" <> id} = map) when is_map(map) do
    Inventory.get_accessories!(id)
    |> stringify_map
    |> Map.merge(%{"id" => Ecto.UUID.generate(), "inventory_id" => "prod_" <> id})
  rescue
    Ecto.NoResultsError ->
      raise Exception.InventoryNotFound, id
  end

  defp create_order(%{"id" => id}),
    do: raise(Exception.InventoryNotFound, message: "Malformed id: no prefix found for #{id}")

  defp create_order(prod_id, %{"id" => "acc_" <> id}) do
    %{accessories: accessories} =
      Assoc.get_product_accessories_by!(product_id: prod_id, accessories_id: id)
      |> Repo.preload([:accessories])

    stringify_map(accessories)
  rescue
    Ecto.NoResultsError ->
      raise Exception.InventoryNotFound,
        message: "no accessory with #{id} associated with this product"
  end
end

defmodule Haberdash.Transactions.AccessoriesItem do
  use Ecto.Schema
  import Ecto.Changeset
  alias Haberdash.{Inventory}
  @derive {Poison.Encoder, except: [:__meta__]}
  @primary_key {:id, :binary_id, autogenerate: true}
  embedded_schema do
    field :name, :string
    field :item_id, :binary_id
    field :description, :string
    field :message, :string, virtual: true
    field :price, :integer
  end

  def changeset(accessories, attrs) do
    item_id = Map.get(attrs, "item_id", nil) || Map.get(attrs, :item_id, nil)
    accessories_entry = Inventory.get_accessories!(item_id)

    accessories_item = %{
      name: accessories_entry.name,
      description: accessories_entry.description,
      price: accessories_entry.price,
      accessories_id: accessories_entry.id
    }

    accessories
    |> cast(accessories_item, [:name, :item_id, :description, :price])
  end
end
