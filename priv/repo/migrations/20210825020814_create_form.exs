defmodule Forms.Repo.Migrations.CreateForm do
  use Ecto.Migration

  def change do
    create table(:form, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :description, :string
      add :questions, {:array, :map}
      add :owner_id, references(:owner, on_delete: :nothing, type: :binary_id)
      add :url, :string

      timestamps()
    end

    create index(:form, [:owner_id])
  end
end
