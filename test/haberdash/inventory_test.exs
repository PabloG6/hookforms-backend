defmodule Haberdash.InventoryTest do
  use Haberdash.DataCase

  alias Haberdash.Inventory

  describe "product" do
    alias Haberdash.Inventory.Products

    @valid_attrs %{
      description: "some description",
      name: "some name",
      price: "120.5",
      price_id: "some price_id"
    }
    @update_attrs %{
      description: "some updated description",
      name: "some updated name",
      price: "456.7",
      price_id: "some updated price_id"
    }
    @invalid_attrs %{description: nil, name: nil, price: nil, price_id: nil}

    def products_fixture(attrs \\ %{}) do
      {:ok, products} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Inventory.create_products()

      products
    end

    test "list_product/0 returns all product" do
      products = products_fixture()
      assert Inventory.list_product() == [products]
    end

    test "get_products!/1 returns the products with given id" do
      products = products_fixture()
      assert Inventory.get_products!(products.id) == products
    end

    test "create_products/1 with valid data creates a products" do
      assert {:ok, %Products{} = products} = Inventory.create_products(@valid_attrs)
      assert products.description == "some description"
      assert products.name == "some name"
      assert products.price == Decimal.new("120.5")
      assert products.price_id == "some price_id"
    end

    test "create_products/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Inventory.create_products(@invalid_attrs)
    end

    test "update_products/2 with valid data updates the products" do
      products = products_fixture()
      assert {:ok, %Products{} = products} = Inventory.update_products(products, @update_attrs)
      assert products.description == "some updated description"
      assert products.name == "some updated name"
      assert products.price == Decimal.new("456.7")
      assert products.price_id == "some updated price_id"
    end

    test "update_products/2 with invalid data returns error changeset" do
      products = products_fixture()
      assert {:error, %Ecto.Changeset{}} = Inventory.update_products(products, @invalid_attrs)
      assert products == Inventory.get_products!(products.id)
    end

    test "delete_products/1 deletes the products" do
      products = products_fixture()
      assert {:ok, %Products{}} = Inventory.delete_products(products)
      assert_raise Ecto.NoResultsError, fn -> Inventory.get_products!(products.id) end
    end

    test "change_products/1 returns a products changeset" do
      products = products_fixture()
      assert %Ecto.Changeset{} = Inventory.change_products(products)
    end
  end
end
