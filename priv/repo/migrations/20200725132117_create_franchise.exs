defmodule Haberdash.Repo.Migrations.CreateFranchise do
  use Ecto.Migration

  def change do
    create table(:franchise, primary_key: false) do
      add :name, :string
      add :description, :text
      add :phone_number, :string
      add :owner_id, references(:owner, type: :binary_id, on_delete: :delete_all)
      add :id, :binary_id, primary_key: true
      timestamps()
    end
    create unique_index(:franchise, [:phone_number])
  end

end
