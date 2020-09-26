defmodule Haberdash.Repo.Migrations.CreateCheckout do
  use Ecto.Migration

  def change do
    create table(:checkout, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :orders_id, references(:orders, type: :binary_id)
      add :customer_id, references(:customer, type: :binary_id)

      timestamps()
    end

  end
end
