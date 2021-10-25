defmodule Forms.AccountsTest do
  use Forms.DataCase

  alias Forms.Accounts

  describe "owner" do
    alias Forms.Accounts.Owner

    @valid_attrs %{email: "some email", password_hash: "some password_hash"}
    @update_attrs %{email: "some updated email", password_hash: "some updated password_hash"}
    @invalid_attrs %{email: nil, password_hash: nil}

    def owner_fixture(attrs \\ %{}) do
      {:ok, owner} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_owner()

      owner
    end

    test "list_owner/0 returns all owner" do
      owner = owner_fixture()
      assert Accounts.list_owner() == [owner]
    end

    test "get_owner!/1 returns the owner with given id" do
      owner = owner_fixture()
      assert Accounts.get_owner!(owner.id) == owner
    end

    test "create_owner/1 with valid data creates a owner" do
      assert {:ok, %Owner{} = owner} = Accounts.create_owner(@valid_attrs)
      assert owner.email == "some email"
      assert owner.password_hash == "some password_hash"
    end

    test "create_owner/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_owner(@invalid_attrs)
    end

    test "update_owner/2 with valid data updates the owner" do
      owner = owner_fixture()
      assert {:ok, %Owner{} = owner} = Accounts.update_owner(owner, @update_attrs)
      assert owner.email == "some updated email"
      assert owner.password_hash == "some updated password_hash"
    end

    test "update_owner/2 with invalid data returns error changeset" do
      owner = owner_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_owner(owner, @invalid_attrs)
      assert owner == Accounts.get_owner!(owner.id)
    end

    test "delete_owner/1 deletes the owner" do
      owner = owner_fixture()
      assert {:ok, %Owner{}} = Accounts.delete_owner(owner)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_owner!(owner.id) end
    end

    test "change_owner/1 returns a owner changeset" do
      owner = owner_fixture()
      assert %Ecto.Changeset{} = Accounts.change_owner(owner)
    end
  end
end
