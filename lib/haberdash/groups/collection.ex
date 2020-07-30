defmodule Haberdash.Groups.Collection do
  use Ecto.Schema
  alias Haberdash.{Business}
  import Ecto.Changeset
  @primary_key {:id, :binary_id, autogenerate: true}
  schema "collection" do
    field :description, :string
    field :name, :string
    belongs_to :franchise, Business.Franchise, type: :binary_id


    timestamps()
  end

  @doc false
  def changeset(collection, attrs) do
    collection
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
