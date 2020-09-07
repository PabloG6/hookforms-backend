defmodule Haberdash.Repo.Migrations.CreateOwner do
  use Ecto.Migration

  def change do
    create table(:owner, primary_key: false) do
      add :name, :string
      add :email, :string
      add :phone_number, :string
      add :id, :binary_id, primary_key: true
      add :password_hash, :string

      timestamps()
    end

    create unique_index(:owner, [:email])
    create unique_index(:owner, [:phone_number])
  end
end
