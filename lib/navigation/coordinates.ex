defmodule Haberdash.Navigation.Coordinates do
  use Ecto.Schema
  embedded_schema do
    field :latitude, :float
    field :longitude, :float
  end
end
