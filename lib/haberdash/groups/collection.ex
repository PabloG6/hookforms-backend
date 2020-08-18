defmodule Haberdash.Groups.Collection do
  use Ecto.Schema
  alias Haberdash.{Business, Assoc}
  import Ecto.Changeset
  @primary_key {:id, :binary_id, autogenerate: true}
  schema "collection" do
    field :description, :string
    field :name, :string
    belongs_to :franchise, Business.Franchise, type: :binary_id
    has_many :products, Assoc.ProductGroups

    timestamps()
  end

  @doc false
  def changeset(collection, attrs) do
    collection
    |> cast(attrs, [:name, :description, :franchise_id])
    |> validate_required([:name, :description, :franchise_id])
  end
end
