defmodule Haberdash.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def up do
    Haberdash.Transactions.DeliveryType.create_type()
    create table(:orders, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :drop_off_address, :map
      add :delivery_type, Haberdash.Transactions.DeliveryType.type()
      add :franchise_id, references(:franchise, type: :binary_id)
      add :items, {:array, :map}, null: false

      timestamps()
    end

  end

  def down do
    drop table(:orders)
    Haberdash.Transactions.DeliveryType.drop_type()
  end
end
