defmodule Haberdash.Inventory.Products do
  use Ecto.Schema
  import Ecto.Changeset
  alias Haberdash.{Business, Assoc, Groups, Inventory}
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Poison.Encoder, except: [:__struct__, :__meta__]}

  schema "product" do
    field :description, :string
    field :name, :string
    field :price, :integer
    belongs_to :franchise, Business.Franchise, type: :binary_id

    many_to_many :collection, Groups.Collection,
      join_through: Assoc.ProductGroups,
      join_keys: [product_id: :id, collection_id: :id]

    many_to_many :accessories, Inventory.Accessories,
      join_through: Assoc.ProductAccessories,
      join_keys: [product_id: :id, accessories_id: :id]

    timestamps()
  end

  @doc false
  def changeset(products, attrs) do
    products
    |> cast(attrs, [:name, :price, :description, :franchise_id])
    |> validate_required([:name, :price, :description, :franchise_id])
  end
end
