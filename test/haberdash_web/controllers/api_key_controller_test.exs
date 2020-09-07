defmodule HaberdashWeb.ApiKeyControllerTest do
  use HaberdashWeb.ConnCase
  import Haberdash.Factory
  alias Haberdash.{Auth, Account}
  alias Haberdash.Auth.ApiKey

  @update_attrs %{
    api_key: "some updated api_key",
    developer_id: "7488a646-e31f-11e4-aace-600308960668"
  }
  @invalid_attrs %{api_key: nil, developer_id: nil}

  def fixture(:api_key) do
    developer = insert(:developer)
    {:ok, api_key} = Auth.create_api_key(%{developer_id: developer.id})
    {developer, api_key}
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  def init(%{conn: conn}) do
    developer = insert(:developer)
    insert(:franchise, %{owner_id: developer.owner_id})
    {:ok, token, _claims} = Auth.Guardian.encode_and_sign(developer)
    conn = put_req_header(conn, "authorization", "Bearer " <> token)
    {:ok, developer: developer, conn: conn}
  end

  describe "index" do
    setup [:init]

    test "lists all api_key", %{conn: conn, developer: developer} do
      conn = get(conn, Routes.api_key_path(conn, :index, developer.id))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create api_key" do
    setup [:init]

    test "renders api_key when data is valid", %{
      conn: conn,
      developer: %Account.Developer{id: developer_id}
    } do
      conn =
        post(conn, Routes.api_key_path(conn, :create), api_key: %{developer_id: developer_id})

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.api_key_path(conn, :show, id))

      assert %{
               "id" => id,
               "developer_id" => developer_id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.api_key_path(conn, :create), api_key: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete api_key" do
    setup [:init, :create_api_key]

    test "deletes chosen api_key", %{conn: conn, api_key: api_key, developer: developer} do
      conn = delete(conn, Routes.api_key_path(conn, :delete, api_key))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.api_key_path(conn, :show, api_key))
      end
    end
  end

  defp create_api_key(_) do
    {developer, api_key} = fixture(:api_key)
    %{api_key: api_key, developer: developer}
  end
end
