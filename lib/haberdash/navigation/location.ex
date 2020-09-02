defmodule Haberdash.Navigation.Location do
  use Ecto.Schema
  import Ecto.Changeset
  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Poison.Encoder, except: [:__struct__, :__meta__,]}

  embedded_schema do
    field :address, :string
    field :coordinates, {:array, :integer}

    timestamps()
  end

  @doc false
  def changeset(location, attrs) do
    location
    |> cast(attrs, [:coordinates, :address])
    |> validate_required([:coordinates, :address])
  end
end
