defmodule Haberdash.Repo.Migrations.CreateProduct do
  use Ecto.Migration

  def change do
    create table(:product) do
      add :name, :text
      add :price, :decimal
      add :description, :text
      add :price_id, :string
      add :franchise_id, references(:franchise, on_delete: :delete_all, type: :binary_id)
      timestamps()
    end
  end
end
