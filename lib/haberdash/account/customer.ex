defmodule Haberdash.Account.Customer do
  use Ecto.Schema
  import Ecto.Changeset
  alias Haberdash.{Navigation}
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "customer" do
    embeds_one :coordinates, Navigation.Coordinates
    field :street_address, :string
    field :apartment_number, :string
    field :city, :string
    field :country, :string
    field :email_address, :string
    field :phone_number, :string
    field :is_activated, :boolean, default: false
    field :is_email_confirmed, :boolean, default: false
    field :is_phone_number_confirmed, :boolean, default: false
    field :first_name, :string
    field :last_name, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  @doc false
  def changeset(customer, attrs) do
    customer
    |> cast(attrs, [
      :name,
      :street_address,
      :city,
      :country,
      :coordinates,
      :email_address,
      :password,
      :is_activated,
      :phone_number,
      :password_hash,
      :is_email_confirmed,
      :is_phone_number_confirmed
    ])
    |> put_password_hash()
    |> validate_required([
      :name,
      :coordinates,
      :email_address,
      :phone_number,
      :is_activated,
      :is_email_confirmed,
      :is_phone_number_confirmed
    ])

  end

  defp put_password_hash(changes), do: changes


end
