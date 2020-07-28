defmodule Haberdash.AccountTest do
  use Haberdash.DataCase

  alias Haberdash.Account

  describe "owner" do
    alias Haberdash.Account.Owner

    @valid_attrs %{
      email: "some email",
      name: "some name",
      phone_number: "some phone_number",
      password: "some password"
    }
    @update_attrs %{
      email: "some updated email",
      name: "some updated name",
      phone_number: "some updated phone_number",
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
      assert owner.email == "some email"
      assert owner.name == "some name"
      assert owner.phone_number == "some phone_number"
    end

    test "create_owner/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_owner(@invalid_attrs)
    end

    test "update_owner/2 with valid data updates the owner" do
      owner = owner_fixture()
      assert {:ok, %Owner{} = owner} = Account.update_owner(owner, @update_attrs)
      assert owner.email == "some updated email"
      assert owner.name == "some updated name"
      assert owner.phone_number == "some updated phone_number"
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
    alias Haberdash.Account.Developers

    @valid_attrs %{
      api_key: "some api_key",
      email: "some email",
      name: "some name",
      password_hash: "some password_hash"
    }
    @update_attrs %{
      api_key: "some updated api_key",
      email: "some updated email",
      name: "some updated name",
      password_hash: "some updated password_hash"
    }
    @invalid_attrs %{api_key: nil, email: nil, name: nil, password_hash: nil}

    def developers_fixture(attrs \\ %{}) do
      {:ok, developers} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Account.create_developers()

      developers
    end

    test "list_developer/0 returns all developer" do
      developers = developers_fixture()
      assert Account.list_developer() == [developers]
    end

    test "get_developers!/1 returns the developers with given id" do
      developers = developers_fixture()
      assert Account.get_developers!(developers.id) == developers
    end

    test "create_developers/1 with valid data creates a developers" do
      assert {:ok, %Developers{} = developers} = Account.create_developers(@valid_attrs)
      assert developers.api_key == "some api_key"
      assert developers.email == "some email"
      assert developers.name == "some name"
      assert developers.password_hash == "some password_hash"
    end

    test "create_developers/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_developers(@invalid_attrs)
    end

    test "update_developers/2 with valid data updates the developers" do
      developers = developers_fixture()

      assert {:ok, %Developers{} = developers} =
               Account.update_developers(developers, @update_attrs)

      assert developers.api_key == "some updated api_key"
      assert developers.email == "some updated email"
      assert developers.name == "some updated name"
      assert developers.password_hash == "some updated password_hash"
    end

    test "update_developers/2 with invalid data returns error changeset" do
      developers = developers_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_developers(developers, @invalid_attrs)
      assert developers == Account.get_developers!(developers.id)
    end

    test "delete_developers/1 deletes the developers" do
      developers = developers_fixture()
      assert {:ok, %Developers{}} = Account.delete_developers(developers)
      assert_raise Ecto.NoResultsError, fn -> Account.get_developers!(developers.id) end
    end

    test "change_developers/1 returns a developers changeset" do
      developers = developers_fixture()
      assert %Ecto.Changeset{} = Account.change_developers(developers)
    end
  end
end
