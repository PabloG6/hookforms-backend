defmodule Haberdash.Repo.Migrations.CreateProductGroups do
  use Ecto.Migration
  @primary_key {:id, :binary_id, autogenerate: true}
  def change do
    create table(:product_groups, primary_key: false) do
      add :product_id, references(:product, type: :string)
      add :collection_id, references(:collection, type: :binary_id)
      add :id, :binary_id, primary_key: true
      timestamps()
    end


    create unique_index(:product_groups, [:product_id, :collection_id], name: :product_group_index)
  end
end
