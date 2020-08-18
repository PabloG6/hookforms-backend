defmodule Haberdash.Assoc.ProductGroups do
  use Ecto.Schema
  import Ecto.Changeset
  alias Haberdash.{Inventory, Groups}
  @primary_key {:id, :binary_id, autogenerate: true}
  schema "product_groups" do
    belongs_to :product, Inventory.Products, type: :binary_id
    belongs_to :collection, Groups.Collection, type: :binary_id
    timestamps()
  end

  @doc false
  def changeset(product_groups, attrs) do

    product_groups
    |> cast(attrs, [:product_id, :collection_id])
    |> validate_required([:product_id, :collection_id])
    |> unique_constraint(:product_id, name: :product_collection_index)
    |> foreign_key_constraint(:product_id)
    |> foreign_key_constraint(:collection_id)
  end
end
