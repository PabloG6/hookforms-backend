defmodule Haberdash.Inventory.Accessories do
  use Ecto.Schema
  import Ecto.Changeset
  alias Haberdash.{Business, Inventory}
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accessories" do
    belongs_to :franchise, Business.Franchise
    field :price, :decimal
    field :title, :string
    field :description, :string
    belongs_to :product, Inventory.Products
    field :max_quantity, :integer, default: 2
    timestamps()
  end


  @doc false
  def changeset(accessories, attrs) do
    accessories
    |> cast(attrs, [:title, :price, :description, :franchise, :franchise_id, :max_quantity, :product_id])
    |> validate_required([:title, :price, :desription, :franchise, :franchise_id, :product_id])
  end
end
