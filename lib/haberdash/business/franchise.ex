defmodule Haberdash.Business.Franchise do
  use Ecto.Schema
  import Ecto.Changeset
  alias Haberdash.{Account, Inventory}
  @primary_key {:id, :binary_id, autogenerate: true}

  schema "franchise" do
    field :description, :string
    field :name, :string
    field :phone_number, :string
    belongs_to :owner, Account.Owner, type: :binary_id
    has_many :inventory, Inventory.Products
    timestamps()
  end

  @doc false
  def changeset(franchise, attrs) do
    franchise
    |> cast(attrs, [:name, :description, :phone_number, :owner_id])
    |> validate_required([:name, :description, :phone_number, :owner_id])
  end
end
