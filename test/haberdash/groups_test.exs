defmodule Haberdash.GroupsTest do
  use Haberdash.DataCase

  alias Haberdash.Groups

  setup do
    :ok
  end
  describe "collection" do
    setup [:create_franchise]
    alias Haberdash.Groups.Collection
    alias Haberdash.{Account, Business}

    @valid_attrs %{description: "some description", name: "some name"}
    @update_attrs %{description: "some updated description", name: "some updated name"}
    @invalid_attrs %{description: nil, name: nil}
    @franchise_attrs %{
      description: "some description",
      name: "some name",
      phone_number: "+4588913544"
    }

    @owner_attrs %{
      email: "random@email.com",
      name: "some name",
      phone_number: "+458891458",
      password: "some password"
    }

    def collection_fixture(attrs \\ %{}) do
      {:ok, collection} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Groups.create_collection()

      collection
    end

    test "list_collection/0 returns all collection", %{franchise: franchise} do
      collection = collection_fixture(%{franchise_id: franchise.id})
      assert Groups.list_collection(franchise.id) == [collection]
    end

    test "get_collection!/1 returns the collection with given id", %{franchise: franchise} do
      collection = collection_fixture(%{franchise_id: franchise.id})
      assert Groups.get_collection!(collection.id) == collection
    end

    test "create_collection/1 with valid data creates a collection", %{franchise: franchise} do
      assert {:ok, %Collection{} = collection} = Groups.create_collection(@valid_attrs |> Enum.into(%{franchise_id: franchise.id}))
      assert collection.description == "some description"
      assert collection.name == "some name"
    end

    test "create_collection/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Groups.create_collection(@invalid_attrs)
    end

    test "update_collection/2 with valid data updates the collection", %{franchise: franchise} do
      collection = collection_fixture(%{franchise_id: franchise.id})
      assert {:ok, %Collection{} = collection} = Groups.update_collection(collection, @update_attrs)
      assert collection.description == "some updated description"
      assert collection.name == "some updated name"
    end

    test "update_collection/2 with invalid data returns error changeset", %{franchise: franchise} do
      collection = collection_fixture(%{franchise_id: franchise.id})
      assert {:error, %Ecto.Changeset{}} = Groups.update_collection(collection, @invalid_attrs)
      assert collection == Groups.get_collection!(collection.id)
    end

    test "delete_collection/1 deletes the collection", %{franchise: franchise} do
      collection = collection_fixture(%{franchise_id: franchise.id})
      assert {:ok, %Collection{}} = Groups.delete_collection(collection)
      assert_raise Ecto.NoResultsError, fn -> Groups.get_collection!(collection.id) end
    end

    test "change_collection/1 returns a collection changeset", %{franchise: franchise} do
      collection = collection_fixture(%{franchise_id: franchise.id})
      assert %Ecto.Changeset{} = Groups.change_collection(collection)
    end
    defp create_franchise(_) do
      {:ok, owner} = Account.create_owner(@owner_attrs)
      {:ok, franchise} = Business.create_franchise(%{owner_id: owner.id} |> Enum.into(@franchise_attrs))
      %{franchise: franchise}
    end
  end


end
