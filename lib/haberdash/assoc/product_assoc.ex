defmodule Haberdash.Assoc.ProductAssoc do
  use Ecto.Schema
  import Ecto.Changeset
  alias Haberdash.{Inventory}
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "product_assoc" do
    belongs_to :product, Inventory.Products
    belongs_to :accessories, Inventory.Products

    timestamps()
  end

  @doc false
  def changeset(product_assoc, attrs) do
    product_assoc
    |> cast(attrs, [:product_id, :accessories_id])
    |> validate_required([:product_id, :accessories_id])
  end
end
