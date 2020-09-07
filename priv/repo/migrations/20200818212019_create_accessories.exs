defmodule Haberdash.Repo.Migrations.CreateAccessories do
  use Ecto.Migration

  def change do
    create table(:accessories, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :price, :integer, default: 0
      add :max_quantity, :integer, default: 2
      add :franchise_id, references(:franchise, type: :uuid, on_delete: :nothing)
      add :description, :string
      timestamps()
    end
  end
end
