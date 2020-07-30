defmodule Haberdash.BusinessTest do
  use Haberdash.DataCase

  alias Haberdash.{Business, Account}

  describe "franchise" do
    alias Haberdash.Business.Franchise

    @valid_attrs %{
      description: "some description",
      name: "some name",
      phone_number: "+4588913544"
    }

    @owner_attrs %{
      email: "random@email.com",
      name: "some name",
      phone_number: "+458891458",
      password: "password"
    }

    @update_attrs %{
      description: "some updated description",
      name: "some updated name",
      phone_number: "+4588914934"
    }
    @invalid_attrs %{description: nil, name: nil, phone_number: nil}

    def franchise_fixture(attrs \\ %{}) do
      {:ok, owner} = Account.create_owner(@owner_attrs)
      {:ok, franchise} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Enum.into(%{owner_id: owner.id})
        |> Business.create_franchise()

      franchise
    end

    test "list_franchise/0 returns all franchise" do
      franchise = franchise_fixture()
      assert Business.list_franchises() == [franchise]
    end

    test "get_franchise!/1 returns the franchise with given id" do
      franchise = franchise_fixture()
      assert Business.get_franchise!(franchise.id) == franchise
    end

    test "create_franchise/1 with valid data creates a franchise" do
      assert {:ok, %Account.Owner{} = owner} = Account.create_owner(@owner_attrs)
      assert {:ok, %Franchise{} = franchise} = Business.create_franchise(@valid_attrs |> Enum.into(%{owner_id: owner.id}))
      assert franchise.description == "some description"
      assert franchise.name == "some name"
      assert franchise.phone_number == "+4588913544"
    end

    test "create_franchise/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Business.create_franchise(@invalid_attrs)
    end

    test "update_franchise/2 with valid data updates the franchise" do
      franchise = franchise_fixture()
      assert {:ok, %Franchise{} = franchise} = Business.update_franchise(franchise, @update_attrs)
      assert franchise.description == "some updated description"
      assert franchise.name == "some updated name"
      assert franchise.phone_number == "+4588914934"
    end

    test "update_franchise/2 with invalid data returns error changeset" do
      franchise = franchise_fixture()
      assert {:error, %Ecto.Changeset{}} = Business.update_franchise(franchise, @invalid_attrs)
      assert franchise == Business.get_franchise!(franchise.id)
    end

    test "delete_franchise/1 deletes the franchise" do
      franchise = franchise_fixture()
      assert {:ok, %Franchise{}} = Business.delete_franchise(franchise)
      assert_raise Ecto.NoResultsError, fn -> Business.get_franchise!(franchise.id) end
    end

    test "change_franchise/1 returns a franchise changeset" do
      franchise = franchise_fixture()
      assert %Ecto.Changeset{} = Business.change_franchise(franchise)
    end
  end
end
