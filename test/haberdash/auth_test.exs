defmodule Haberdash.AuthTest do
  use Haberdash.DataCase
  import Haberdash.Factory
  alias Haberdash.Auth

  describe "api_key" do
    alias Haberdash.Auth.ApiKey

    @invalid_attrs %{}

    def api_key_fixture(attrs \\ %{}) do
      developer = insert(:developer)

      {:ok, api_key} =
        attrs
        |> Enum.into(%{developer_id: developer.id})
        |> Auth.create_api_key()

      {developer, api_key}
    end

    test "list_api_key/0 returns all api_key" do
      {developer, api_key} = api_key_fixture()
      assert Auth.list_api_key(developer.id) == [api_key]
    end

    test "get_api_key!/1 returns the api_key with given id" do
      {_, api_key} = api_key_fixture()
      assert Auth.get_api_key!(api_key.id) == api_key
    end

    test "create_api_key/1 with valid data creates a api_key" do
      developer = insert(:developer)
      assert {:ok, %ApiKey{} = api_key} = Auth.create_api_key(%{developer_id: developer.id})

      assert api_key.developer_id == developer.id
    end

    test "create_api_key/1 with invalid data returns error changeset" do
      developer = insert(:developer)
      assert {:error, %Ecto.Changeset{}} = Auth.create_api_key(@invalid_attrs)
    end

    test "delete_api_key/1 deletes the api_key" do
      {_, api_key} = api_key_fixture()
      assert {:ok, %ApiKey{}} = Auth.delete_api_key(api_key)
      assert_raise Ecto.NoResultsError, fn -> Auth.get_api_key!(api_key.id) end
    end

    test "change_api_key/1 returns a api_key changeset" do
      {_, api_key} = api_key_fixture()
      assert %Ecto.Changeset{} = Auth.change_api_key(api_key)
    end
  end
end
