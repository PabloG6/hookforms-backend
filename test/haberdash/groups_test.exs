defmodule Haberdash.GroupsTest do
  use Haberdash.DataCase

  alias Haberdash.Groups

  describe "collection" do
    alias Haberdash.Groups.Collection

    @valid_attrs %{description: "some description", name: "some name"}
    @update_attrs %{description: "some updated description", name: "some updated name"}
    @invalid_attrs %{description: nil, name: nil}

    def collection_fixture(attrs \\ %{}) do
      {:ok, collection} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Groups.create_collection()

      collection
    end

    test "list_collection/0 returns all collection" do
      collection = collection_fixture()
      assert Groups.list_collection() == [collection]
    end

    test "get_collection!/1 returns the collection with given id" do
      collection = collection_fixture()
      assert Groups.get_collection!(collection.id) == collection
    end

    test "create_collection/1 with valid data creates a collection" do
      assert {:ok, %Collection{} = collection} = Groups.create_collection(@valid_attrs)
      assert collection.description == "some description"
      assert collection.name == "some name"
    end

    test "create_collection/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Groups.create_collection(@invalid_attrs)
    end

    test "update_collection/2 with valid data updates the collection" do
      collection = collection_fixture()
      assert {:ok, %Collection{} = collection} = Groups.update_collection(collection, @update_attrs)
      assert collection.description == "some updated description"
      assert collection.name == "some updated name"
    end

    test "update_collection/2 with invalid data returns error changeset" do
      collection = collection_fixture()
      assert {:error, %Ecto.Changeset{}} = Groups.update_collection(collection, @invalid_attrs)
      assert collection == Groups.get_collection!(collection.id)
    end

    test "delete_collection/1 deletes the collection" do
      collection = collection_fixture()
      assert {:ok, %Collection{}} = Groups.delete_collection(collection)
      assert_raise Ecto.NoResultsError, fn -> Groups.get_collection!(collection.id) end
    end

    test "change_collection/1 returns a collection changeset" do
      collection = collection_fixture()
      assert %Ecto.Changeset{} = Groups.change_collection(collection)
    end
  end
end
