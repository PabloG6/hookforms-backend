defmodule Haberdash.Repo.Migrations.CreateCollection do
  use Ecto.Migration

  def change do
    create table(:collection, primary_key: false) do
      add :name, :string
      add :description, :string
      add :id, :binary_id, primary_key: true
      add :franchise_id, references(:franchise, type: :binary_id)

      timestamps()
    end

    create unique_index(:collection, [:name, :franchise_id])

  end
end
