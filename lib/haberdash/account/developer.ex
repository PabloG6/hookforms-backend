defmodule Haberdash.Account.Developer do
  use Ecto.Schema
  import Ecto.Changeset
  alias Haberdash.{Account}
  @primary_key {:id, :binary_id, autogenerate: true}
  schema "developer" do
    field :api_key, :string
    field :email, :string
    field :name, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    belongs_to :owner, Account.Owner, type: :binary_id

    timestamps()
  end

  @doc false
  def changeset(developers, attrs) do
    developers
    |> cast(attrs, [:name, :email, :password, :api_key, :owner_id])
    |> validate_required([:name, :email, :password, :api_key, :owner_id])
    |> put_password_hash
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
