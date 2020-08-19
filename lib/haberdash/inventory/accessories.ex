defmodule Haberdash.Inventory.Accessories do
  use Ecto.Schema
  import Ecto.Changeset
  alias Haberdash.{Business, Inventory, Assoc}
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accessories" do
    belongs_to :franchise, Business.Franchise
    field :price, :decimal, default: 0
    field :name, :string
    field :description, :string
    field :max_quantity, :integer, default: 2
    many_to_many :products, Inventory.Products, join_through: Assoc.ProductAccessories
    timestamps()
  end


  @doc false
  def changeset(accessories, attrs) do
    accessories
    |> cast(attrs, [:name, :price, :description, :franchise_id, :max_quantity])
    |> validate_required([:name, :price, :franchise_id])
  end
end
