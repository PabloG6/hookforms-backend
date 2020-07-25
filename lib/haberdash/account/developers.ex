defmodule Haberdash.Account.Developers do
  use Ecto.Schema
  import Ecto.Changeset

  schema "developer" do
    field :api_key, :string
    field :email, :string
    field :name, :string
    field :password_hash, :string

    timestamps()
  end

  @doc false
  def changeset(developers, attrs) do
    developers
    |> cast(attrs, [:name, :email, :password_hash, :api_key])
    |> validate_required([:name, :email, :password_hash, :api_key])
  end
end
