defmodule Haberdash.Inventory.Products do
  use Ecto.Schema
  import Ecto.Changeset
  alias Haberdash.{Business, Assoc}
  @primary_key {:id, :binary_id, autogenerate: true}
  schema "product" do
    field :description, :string
    field :name, :string
    field :price, :decimal
    field :price_id, :string
    belongs_to :franchise, Business.Franchise, type: :binary_id
    has_many :collection, Assoc.ProductGroups
    timestamps()
  end

  @doc false
  def changeset(products, attrs) do
    products
    |> cast(attrs, [:name, :price, :description, :price_id, :franchise_id])
    |> validate_required([:name, :price, :description, :price_id, :franchise_id])
  end
end
