defmodule Haberdash.Repo.Migrations.CreateCustomer do
  use Ecto.Migration

  def change do
    create table(:customer, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :formatted_address, :string
      add :coordinates, {:array, :float}
      add :email_address, :string
      add :phone_number, :string
      add :is_activated, :boolean, default: false, null: false
      add :password_hash, :string
      add :is_email_confirmed, :boolean, default: false, null: false
      add :is_phone_number_confirmed, :boolean, default: false, null: false

      timestamps()
    end
  end
end
