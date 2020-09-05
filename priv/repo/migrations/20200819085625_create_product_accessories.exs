defmodule Haberdash.Repo.Migrations.CreateProductAccessories do
  use Ecto.Migration

  def change do
    create table(:product_accessories, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :product_id, references(:product, type: :binary_id)
      add :accessories_id, references(:accessories, type: :binary_id)

      timestamps()
    end

  end
end
