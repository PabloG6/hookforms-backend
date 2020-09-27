defmodule Haberdash.Transactions.OrderItems do
  use Ecto.Schema
  import Ecto.Changeset
  @derive [Poison.Encoder]
  alias Haberdash.{Transactions}
  @primary_key {:id, :binary_id, autogenerate: true}
  embedded_schema do
    field :name, :string
    field :inventory_id, :binary_id
    field :description, :string
    field :price, :integer
    field :message, :string, virtual: true
    embeds_many :accessories, Transactions.Accessories
  end

  def changeset(item, attrs) do
    item
    |> cast(attrs, [:name, :inventory_id, :description, :price])
    |> cast_embed(:accessories)
  end
end
