defmodule Haberdash.Repo.Migrations.CreateAccessories do
  use Ecto.Migration

  def change do
    create table(:accessories, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :price, :integer
      add :franchise, :uuid

      timestamps()
    end

  end
end
