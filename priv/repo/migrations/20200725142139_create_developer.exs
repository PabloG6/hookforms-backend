defmodule Haberdash.Repo.Migrations.CreateDeveloper do
  use Ecto.Migration

  def change do
    create table(:developer, primary_key: false) do
      add :name, :string
      add :email, :string
      add :password_hash, :string
      add :id, :binary_id, primary_key: true
      add :owner_id, references(:owner, on_delete: :nothing, type: :binary_id)
      timestamps()
    end
  end
end
