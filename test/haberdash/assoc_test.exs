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
      price: 9999,
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
    setup [:init]
    alias Haberdash.Assoc.ProductAccessories

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
      price: 9999,
      price_id: "some price_id"
    }
    @accessory_attrs %{name: "Large Fries", description: "A large fries", price: 999, }
    def product_accessories_fixture(attrs \\ %{}) do
      {:ok, product_accessories} =
        attrs
        |> Assoc.create_product_accessories()

      product_accessories
    end

    test "list_product_accessories/0 returns all product_accessories", %{product: product, accessories: accessories} do
      product_accessories = product_accessories_fixture(%{product_id: product.id, accessories_id: accessories.id})
      assert Assoc.list_product_accessories() == [product_accessories]
    end

    test "get_product_accessories!/1 returns the product_accessories with given id", %{product: product, accessories: accessories} do
      product_accessories = product_accessories_fixture(%{product_id: product.id, accessories_id: accessories.id})
      assert Assoc.get_product_accessories!(product_accessories.id) == product_accessories
    end

    test "create_product_accessories/1 with valid data creates a product_accessories", %{product: product, accessories: accessories} do
      assert {:ok, %ProductAccessories{} = product_accessories} = Assoc.create_product_accessories(%{product_id: product.id, accessories_id: accessories.id})
      assert product_accessories.accessories_id == accessories.id
      assert product_accessories.product_id == product.id
    end

    test "create_product_accessories/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Assoc.create_product_accessories(@invalid_attrs)
    end




    test "delete_product_accessories/1 deletes the product_accessories", %{product: product, accessories: accessories} do
      product_accessories = product_accessories_fixture(%{product_id: product.id, accessories_id: accessories.id})
      assert {:ok, %ProductAccessories{}} = Assoc.delete_product_accessories(product_accessories)
      assert_raise Ecto.NoResultsError, fn -> Assoc.get_product_accessories!(product_accessories.id) end
    end

    test "change_product_accessories/1 returns a product_accessories changeset", %{product: product, accessories: accessories} do
      product_accessories = product_accessories_fixture(%{product_id: product.id, accessories_id: accessories.id})
      assert %Ecto.Changeset{} = Assoc.change_product_accessories(product_accessories)
    end

    defp init(_) do
      {:ok, owner} = Account.create_owner(@owner_attrs)
      {:ok, franchise} = Business.create_franchise(@franchise_attrs |> Enum.into(%{owner_id: owner.id}))

      {:ok, product} = Inventory.create_products(@product_attrs |> Enum.into(%{franchise_id: franchise.id}))

      {:ok, accessories} = Inventory.create_accessories(@accessory_attrs |> Enum.into(%{franchise_id: franchise.id}))
      {:ok, accessories: accessories, product: product, franchise: franchise}
    end
  end
end
