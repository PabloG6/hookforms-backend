defmodule Haberdash.Repo.Migrations.ApiKey do
  use Ecto.Migration

  def change do
    create table(:api_key, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :api_key, :string, null: false
      add :developer_id, references(:developer, type: :binary_id)
      timestamps(type: :utc_datetime_usec)
    end
  end
end
