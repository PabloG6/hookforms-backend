defmodule Forms.Accounts.Owner do
  use Ecto.Schema
  import Ecto.Changeset
  require Logger

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "owner" do
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  @doc false
  def changeset(owner, attrs) do
    owner
    |> cast(attrs, [:email, :password])
    |> put_password_hash
    |> validate_required([:email, :password_hash])
    |> unique_constraint(:email)
  end

  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: nil}} = changeset), do: changeset
  defp put_password_hash(%Ecto.Changeset{changes: %{password: password}} = changeset ) do
    Logger.info(password)
    change(changeset, %{password_hash: Bcrypt.hash_pwd_salt(password)})

  end

  defp put_password_hash(changeset), do: changeset
end
