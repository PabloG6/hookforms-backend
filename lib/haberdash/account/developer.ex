defmodule Haberdash.Account.Developer do
  use Ecto.Schema
  import Ecto.Changeset
  alias Haberdash.{Account}

  schema "developer" do
    field :api_key, :string
    field :email, :string
    field :name, :string
    field :password_hash, :string
    belongs_to :owner, Account.Owner

    timestamps()
  end

  @doc false
  def changeset(developers, attrs) do
    developers
    |> cast(attrs, [:name, :email, :password_hash, :api_key, :owner_id])
    |> validate_required([:name, :email, :password_hash, :api_key, :owner_id])
  end
end
