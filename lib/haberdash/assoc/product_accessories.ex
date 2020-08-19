defmodule Haberdash.Assoc.ProductAccessories do
  use Ecto.Schema
  import Ecto.Changeset
  alias Haberdash.{Inventory}
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "product_accessories" do
    belongs_to :accessories, Inventory.Accessories
    belongs_to :product, Inventory.Products

    timestamps()
  end

  @doc false
  def changeset(product_accessories, attrs) do
    product_accessories
    |> cast(attrs, [:product_id, :accessories_id])
    |> validate_required([:product_id, :accessories_id])
  end
end
