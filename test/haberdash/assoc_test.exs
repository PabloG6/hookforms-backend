defmodule Haberdash.AssocTest do
  use Haberdash.DataCase

  alias Haberdash.{Assoc, Account, Business, Inventory, Groups}


  setup do
    :ok
  end
  describe "product_groups" do
    setup [:fixture]
    alias Haberdash.Assoc.ProductGroups
    @owner_attrs %{
      email: "some@email.com",
      name: "some name",
      phone_number: "+4915843854",
      password: "some password"
    }

    @franchise_attrs %{
      description: "some description",
      name: "some name",
      phone_number: "+4588913544"
    }


    @product_attrs %{
      description: "some description",
      name: "some name",
      price: "120.5",
      price_id: "some price_id"
    }
    @group_attrs %{description: "some description", name: "some name"}
    @invalid_attrs %{collection_id: nil, product_id: nil}

    def product_groups_fixture(attrs \\ %{}) do

      {:ok, product_groups} = Assoc.create_product_groups(attrs)

      product_groups
    end

    test "list_product_groups/0 returns all product_groups", %{collection: collection, product: product} do
      product_groups = product_groups_fixture(%{collection_id: collection.id, product_id: product.id})
      assert Assoc.list_product_groups() == [product_groups]
    end

    test "get_product_groups!/1 returns the product_groups with given id", %{collection: collection, product: product} do
      product_groups = product_groups_fixture(%{collection_id: collection.id, product_id: product.id})
      assert Assoc.get_product_groups!(product_groups.id) == product_groups
    end

    test "create_product_groups/1 with valid data creates a product_groups", %{collection: collection, product: product} do
      assert {:ok, %ProductGroups{} = product_groups} = Assoc.create_product_groups(%{collection_id: collection.id, product_id: product.id})
      assert product_groups.collection_id == collection.id
      assert product_groups.product_id == product.id
    end

    test "create_product_groups/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Assoc.create_product_groups(@invalid_attrs)
    end

    test "list_collection_product_info/1 return valid list of preloaded product_group", %{product: product, collection: collection} do
      product_groups = product_groups_fixture(%{collection_id: collection.id, product_id: product.id})
      [head | _tail] = Assoc.list_collection_product_info(collection.id)
      assert [%{head | product: nil, collection: nil}] == [%{product_groups | collection: nil, product: nil}]
    end

    test "list_product_collection_info/1 return valid list of preloaded product_group", %{product: product, collection: collection} do
      product_groups = product_groups_fixture(%{collection_id: collection.id, product_id: product.id})
      [head | _tail] = Assoc.list_product_group_info(product.id)
      assert [%{head | product: nil, collection: nil}] == [%{product_groups | collection: nil, product: nil}]
    end



    test "delete_product_groups/1 deletes the product_groups", %{collection: collection, product: product} do
      product_groups = product_groups_fixture(%{product_id: product.id, collection_id: collection.id})
      assert {:ok, %ProductGroups{}} = Assoc.delete_product_groups(product_groups)
      assert_raise Ecto.NoResultsError, fn -> Assoc.get_product_groups!(product_groups.id) end
    end

    test "change_product_groups/1 returns a product_groups changeset", %{collection: collection, product: product} do
      product_groups = product_groups_fixture(%{collection_id: collection.id, product_id: product.id})
      assert %Ecto.Changeset{} = Assoc.change_product_groups(product_groups)
    end

    def fixture(_) do
      {:ok, owner} = Account.create_owner(@owner_attrs)
      {:ok, franchise} = Business.create_franchise(@franchise_attrs |> Enum.into(%{owner_id: owner.id}))
      {:ok, product} = Inventory.create_products(@product_attrs |> Enum.into(%{franchise_id: franchise.id}))
      {:ok, collection} = Groups.create_collection(@group_attrs |> Enum.into(%{franchise_id: franchise.id}))
      {:ok, collection: collection, product: product}
    end
  end



  describe "product_accessories" do
    alias Haberdash.Assoc.ProductAccessories

    @valid_attrs %{accessories_id: "7488a646-e31f-11e4-aace-600308960662", product_id: "7488a646-e31f-11e4-aace-600308960662"}
    @update_attrs %{accessories_id: "7488a646-e31f-11e4-aace-600308960668", product_id: "7488a646-e31f-11e4-aace-600308960668"}
    @invalid_attrs %{accessories_id: nil, product_id: nil}

    def product_accessories_fixture(attrs \\ %{}) do
      {:ok, product_accessories} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Assoc.create_product_accessories()

      product_accessories
    end

    test "list_product_accessories/0 returns all product_accessories" do
      product_accessories = product_accessories_fixture()
      assert Assoc.list_product_accessories() == [product_accessories]
    end

    test "get_product_accessories!/1 returns the product_accessories with given id" do
      product_accessories = product_accessories_fixture()
      assert Assoc.get_product_accessories!(product_accessories.id) == product_accessories
    end

    test "create_product_accessories/1 with valid data creates a product_accessories" do
      assert {:ok, %ProductAccessories{} = product_accessories} = Assoc.create_product_accessories(@valid_attrs)
      assert product_accessories.accessories_id == "7488a646-e31f-11e4-aace-600308960662"
      assert product_accessories.product_id == "7488a646-e31f-11e4-aace-600308960662"
    end

    test "create_product_accessories/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Assoc.create_product_accessories(@invalid_attrs)
    end

    test "update_product_accessories/2 with valid data updates the product_accessories" do
      product_accessories = product_accessories_fixture()
      assert {:ok, %ProductAccessories{} = product_accessories} = Assoc.update_product_accessories(product_accessories, @update_attrs)
      assert product_accessories.accessories_id == "7488a646-e31f-11e4-aace-600308960668"
      assert product_accessories.product_id == "7488a646-e31f-11e4-aace-600308960668"
    end

    test "update_product_accessories/2 with invalid data returns error changeset" do
      product_accessories = product_accessories_fixture()
      assert {:error, %Ecto.Changeset{}} = Assoc.update_product_accessories(product_accessories, @invalid_attrs)
      assert product_accessories == Assoc.get_product_accessories!(product_accessories.id)
    end

    test "delete_product_accessories/1 deletes the product_accessories" do
      product_accessories = product_accessories_fixture()
      assert {:ok, %ProductAccessories{}} = Assoc.delete_product_accessories(product_accessories)
      assert_raise Ecto.NoResultsError, fn -> Assoc.get_product_accessories!(product_accessories.id) end
    end

    test "change_product_accessories/1 returns a product_accessories changeset" do
      product_accessories = product_accessories_fixture()
      assert %Ecto.Changeset{} = Assoc.change_product_accessories(product_accessories)
    end
  end
end
