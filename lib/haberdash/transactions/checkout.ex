defmodule Haberdash.Transactions.Checkout do
  use Ecto.Schema
  import Ecto.Changeset
  alias Haberdash.{Transactions, Account}
  schema "checkout" do
    belongs_to :customer, Account.Customer
    belongs_to :orders, Transactions.Orders
    timestamps()
  end

  @doc false
  def changeset(checkout, attrs) do
    checkout
    |> cast(attrs, [:customer_id, :orders_id])
    |> validate_required([:customer_id, :orders_id])
    |> foreign_key_constraint(:customer_id)
    |> foreign_key_constraint(:orders_id)
  end
end
