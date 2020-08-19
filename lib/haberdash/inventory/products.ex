defmodule Haberdash.Inventory.Products do
  use Ecto.Schema
  import Ecto.Changeset
  alias Haberdash.{Business, Assoc, Groups}
  @primary_key {:id, :binary_id, autogenerate: true}
  schema "product" do
    field :description, :string
    field :name, :string
    field :price, :decimal
    belongs_to :franchise, Business.Franchise, type: :binary_id
    many_to_many :collection, Groups.Collection, join_through: Assoc.ProductGroups
    timestamps()
  end

  @doc false
  def changeset(products, attrs) do
    products
    |> cast(attrs, [:name, :price, :description, :franchise_id])
    |> validate_required([:name, :price, :description, :franchise_id])
  end
end
