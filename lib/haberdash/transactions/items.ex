
defmodule Haberdash.Transactions.OrderItems do
  use Ecto.Schema
  import Ecto.Changeset
  alias Haberdash.{Transactions}
  @primary_key {:id, :binary_id, autogenerate: true}
  embedded_schema do
    field :name, :string
    field :item_id, :binary_id
    field :description, :string
    field :price, :integer
    field :message, :string, virtual: true
    field :item_type, Haberdash.Transactions.ItemType, default: :products
    embeds_many :accessories, Transactions.Accessories
  end


 def changeset(item, attrs) do

    item
    |> cast(attrs, [:name, :item_id, :description, :price, :item_type])
    |> validate_required([:item_type])
    |> cast_embed(:accessories)
  end





end
