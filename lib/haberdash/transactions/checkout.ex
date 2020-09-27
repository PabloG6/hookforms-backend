defmodule Haberdash.Transactions.Checkout do
  use Ecto.Schema
  import Ecto.Changeset

  schema "checkout" do
    belongs_to :customer, Account.Customer
    belongs_to :orders, Transactions.Orders
    timestamps()
  end

  @doc false
  def changeset(checkout, attrs) do
    checkout
    |> cast(attrs, [])
    |> validate_required([])
  end
end
