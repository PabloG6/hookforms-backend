defmodule Haberdash.AccountTest do
  use Haberdash.DataCase

  alias Haberdash.Account

  describe "owner" do
    alias Haberdash.Account.Owner

    @valid_attrs %{
      email: "some@email.com",
      name: "some name",
      phone_number: "+4915843854",
      password: "some password"
    }
    @update_attrs %{
      email: "someupdated@email.com",
      name: "some updated name",
      phone_number: "+4915843850",
      password: "some password"
    }
    @invalid_attrs %{email: nil, name: nil, phone_number: nil}

    def owner_fixture(attrs \\ %{}) do
      {:ok, owner} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Account.create_owner()

      owner
    end

    test "list_owner/0 returns all owner" do
      owner = owner_fixture()
      assert Account.list_owner() == [%{owner | password: nil}]
    end

    test "get_owner!/1 returns the owner with given id" do
      owner = owner_fixture()
      assert Account.get_owner!(owner.id) == %{owner | password: nil}
    end

    test "create_owner/1 with valid data creates a owner" do
      assert {:ok, %Owner{} = owner} = Account.create_owner(@valid_attrs)
      assert owner.email == "some@email.com"
      assert owner.name == "some name"
      assert owner.phone_number == "+4915843854"
      assert Bcrypt.verify_pass("some password", owner.password_hash)

    end

    test "create_owner/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_owner(@invalid_attrs)
    end

    test "update_owner/2 with valid data updates the owner" do
      owner = owner_fixture()
      assert {:ok, %Owner{} = owner} = Account.update_owner(owner, @update_attrs)
      assert owner.email == "someupdated@email.com"
      assert owner.name == "some updated name"
      assert owner.phone_number == "+4915843850"
    end

    test "update_owner/2 with invalid data returns error changeset" do
      owner = owner_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_owner(owner, @invalid_attrs)
      assert %{owner | password: nil} == Account.get_owner!(owner.id)
    end

    test "delete_owner/1 deletes the owner" do
      owner = owner_fixture()
      assert {:ok, %Owner{}} = Account.delete_owner(owner)
      assert_raise Ecto.NoResultsError, fn -> Account.get_owner!(owner.id) end
    end

    test "change_owner/1 returns a owner changeset" do
      owner = owner_fixture()
      assert %Ecto.Changeset{} = Account.change_owner(owner)
    end
  end

  describe "developer" do
    alias Haberdash.Account.Developer
    @owner_attrs %{
      email: "some@email.com",
      name: "some name",
      phone_number: "+4915843854",
      password: "some password"
    }
    @valid_attrs %{
      api_key: "some api_key",
      email: "some@email.com",
      name: "some name",
      password: "some password_hash"
    }
    @update_attrs %{
      api_key: "some updated api_key",
      email: "someupdated@email.com",
      name: "some updated name",
      password: "some updated password_hash"
    }
    @invalid_attrs %{api_key: nil, email: nil, name: nil, password: nil}

    def developers_fixture(attrs \\ %{}) do
      {:ok, owner} = Account.create_owner(@owner_attrs)

      {:ok, developers} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Enum.into(%{owner_id: owner.id})
        |> Account.create_developer()

      developers
    end

    test "list_developer/0 returns all developer" do
      developers = developers_fixture()
      assert Account.list_developer() == [%{developers | password: nil}]
    end

    test "get_developers!/1 returns the developers with given id" do
      developers = developers_fixture()
      assert Account.get_developer!(developers.id) == %{ developers | password: nil}
    end

    test "create_developers/1 with valid data creates a developers" do
      assert {:ok, %Account.Owner{id: id}} = Account.create_owner(@owner_attrs)
      assert {:ok, %Developer{} = developers} = Account.create_developer(@valid_attrs |> Enum.into(%{owner_id: id}))
      assert developers.api_key == "some api_key"
      assert developers.email == "some@email.com"
      assert developers.name == "some name"
      assert Bcrypt.verify_pass("some password_hash", developers.password_hash)
    end

    test "create_developers/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_developer(@invalid_attrs)
    end

    test "update_developers/2 with valid data updates the developers" do
      developers = developers_fixture()

      assert {:ok, %Developer{} = developers} =
               Account.update_developer(developers, @update_attrs)

      assert developers.api_key == "some updated api_key"
      assert developers.email == "someupdated@email.com"
      assert developers.name == "some updated name"
      assert Bcrypt.verify_pass("some updated password_hash", developers.password_hash)
    end

    test "update_developers/2 with invalid data returns error changeset" do
      developers = developers_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_developer(developers, @invalid_attrs)
      assert %{developers | password: nil} == Account.get_developer!(developers.id)
    end

    test "delete_developers/1 deletes the developers" do
      developers = developers_fixture()
      assert {:ok, %Developer{}} = Account.delete_developer(developers)
      assert_raise Ecto.NoResultsError, fn -> Account.get_developer!(developers.id) end
    end

    test "change_developers/1 returns a developers changeset" do
      developers = developers_fixture()
      assert %Ecto.Changeset{} = Account.change_developer(developers)
    end
  end
end
