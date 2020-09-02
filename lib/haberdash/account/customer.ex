defmodule Haberdash.Account.Customer do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "customer" do
    field :address, :string
    field :coordinates, {:array, :integer}
    field :email_address, :string
    field :phone_number, :string
    field :is_activated, :boolean, default: false
    field :is_email_confirmed, :boolean, default: false
    field :is_phone_number_confirmed, :boolean, default: false
    field :name, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  @doc false
  def changeset(customer, attrs) do
    customer
    |> cast(attrs, [:name, :address, :coordinates, :email_address, :password, :is_activated, :phone_number, :password_hash, :is_email_confirmed, :is_phone_number_confirmed])
    |> validate_required([:name, :coordinates, :email_address, :phone_number, :is_activated, :is_email_confirmed, :is_phone_number_confirmed])
  end

end
