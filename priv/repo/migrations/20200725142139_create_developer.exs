defmodule Haberdash.Repo.Migrations.CreateDeveloper do
  use Ecto.Migration

  def change do
    create table(:developer) do
      add :name, :string
      add :email, :string
      add :password_hash, :string
      add :api_key, :string

      timestamps()
    end

  end
end
