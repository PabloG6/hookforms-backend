defmodule Haberdash.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :customer_id, :binary, null: true
      add :drop_off_coordinates, :map
      add :drop_off_address, :string
      add :franchise_id, references(:franchise, type: :binary_id)
      add :items, {:array, :map}, null: false

      timestamps()
    end

  end
end
