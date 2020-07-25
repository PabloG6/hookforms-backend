defmodule Haberdash.Inventory.Products do
  use Ecto.Schema
  import Ecto.Changeset
  alias Haberdash.{Business.Franchise}
  schema "product" do
    field :description, :string
    field :name, :string
    field :price, :decimal
    field :price_id, :string
    belongs_to :franchise, Business.Franchise
    timestamps()
  end

  @doc false
  def changeset(products, attrs) do
    products
    |> cast(attrs, [:name, :price, :description, :price_id])
    |> validate_required([:name, :price, :description, :price_id])
  end
end
