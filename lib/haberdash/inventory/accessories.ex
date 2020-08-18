defmodule Haberdash.Inventory.Accessories do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accessories" do
    field :franchise, Ecto.UUID
    field :price, :integer
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(accessories, attrs) do
    accessories
    |> cast(attrs, [:title, :price, :franchise])
    |> validate_required([:title, :price, :franchise])
  end
end
