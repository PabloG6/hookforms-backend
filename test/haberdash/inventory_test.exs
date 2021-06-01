defmodule Haberdash.InventoryTest do
  use Haberdash.DataCase

  alias Haberdash.{Inventory, Account, Business}

  setup do
    :ok
  end

  describe "product" do
    setup [:create_franchise]
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

    @franchise_attrs %{
      description: "some description",
      name: "some name",
      phone_number: "some phone_number"
    }

    @owner_attrs %{
      email: "random@email.com",
      name: "some name",
      phone_number: "+4588913567",
      password: "password"
    }
    @invalid_attrs %{description: nil, name: nil, price: nil, price_id: nil}

    def products_fixture(attrs \\ %{}) do
      {:ok, products} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Inventory.create_products()

      products
    end

    test "list_product/1 returns all product", %{franchise: franchise} do
      products = products_fixture(%{franchise_id: franchise.id})
      assert Inventory.list_product(franchise.id) == [products]
    end

    test "get_products!/1 returns the products with given id", %{franchise: franchise} do
      products = products_fixture(%{franchise_id: franchise.id})
      assert Inventory.get_products!(products.id) == products
    end

    test "create_products/1 with valid data creates a products", %{franchise: franchise} do
      assert {:ok, %Products{} = products} =
               Inventory.create_products(@valid_attrs |> Enum.into(%{franchise_id: franchise.id}))

      assert products.description == "some description"
      assert products.name == "some name"
      assert products.price == Decimal.new("120.5")
    end

    test "create_products/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Inventory.create_products(@invalid_attrs)
    end

    test "update_products/2 with valid data updates the products", %{franchise: franchise} do
      products = products_fixture(%{franchise_id: franchise.id})
      assert {:ok, %Products{} = products} = Inventory.update_products(products, @update_attrs)
      assert products.description == "some updated description"
      assert products.name == "some updated name"
      assert products.price == Decimal.new("456.7")
    end

    test "update_products/2 with invalid data returns error changeset", %{franchise: franchise} do
      products = products_fixture(%{franchise_id: franchise.id})
      assert {:error, %Ecto.Changeset{}} = Inventory.update_products(products, @invalid_attrs)
      assert products == Inventory.get_products!(products.id)
    end

    test "delete_products/1 deletes the products", %{franchise: franchise} do
      products = products_fixture(%{franchise_id: franchise.id})
      assert {:ok, %Products{}} = Inventory.delete_products(products)
      assert_raise Ecto.NoResultsError, fn -> Inventory.get_products!(products.id) end
    end

    test "change_products/1 returns a products changeset", %{franchise: franchise} do
      product = products_fixture(%{franchise_id: franchise.id})
      assert %Ecto.Changeset{} = Inventory.change_products(product)
    end

    defp create_franchise(_) do
      {:ok, owner} = Account.create_owner(@owner_attrs)

      {:ok, franchise} =
        Business.create_franchise(%{owner_id: owner.id} |> Enum.into(@franchise_attrs))

      %{franchise: franchise}
    end
  end

end
