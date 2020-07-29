defmodule Haberdash.Account.Owner do
  use Ecto.Schema
  import Ecto.Changeset
  alias Haberdash.{Business}
  @primary_key {:id, :binary_id, autogenerate: true}

  schema "owner" do
    field :email, :string
    field :name, :string
    field :phone_number, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    has_one :franchise, Business.Franchise
    timestamps()
  end

  @doc false
  def changeset(owner, attrs) do
    owner
    |> cast(attrs, [:name, :email, :phone_number, :password])
    |> put_password_hash
    |> validate_required([:name, :email, :phone_number, :password])
    |> validate_format(:phone_number, ~r/^\+[1-9]\d{1,14}$/, message: "This phone number is invalid")
    |> validate_format(:email,  ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/, message: "This email is invalid")
  end

  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: nil}} = changeset) do
    changeset
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, %{password_hash: Bcrypt.hash_pwd_salt(password)})
  end

  defp put_password_hash(changeset) do
    changeset
  end
end
