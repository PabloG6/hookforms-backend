defmodule HaberdashWeb.DevelopersControllerTest do
  use HaberdashWeb.ConnCase

  alias Haberdash.{Account, Auth}
  alias Haberdash.Account.Developer

  @create_attrs %{
    api_key: "some api_key",
    email: "developer@email.com",
    name: "some name",
    password: "some password_hash"
  }

  @owner_attrs %{
    email: "some@email.com",
    name: "some name",
    phone_number: "+4915843854",
    password: "some password"
  }

  @update_attrs %{
    api_key: "some updated api_key",
    email: "someupdatedemail@email.com",
    name: "some updated name",
    password: "some new password"
  }
  @invalid_attrs %{api_key: nil, email: nil, name: nil, password_hash: nil}

  def fixture(attrs \\ %{}) do
    {:ok, developers} = attrs |> Enum.into(@create_attrs) |> Account.create_developer()
    developers
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all developer", %{conn: conn} do
      conn = get(conn, Routes.developer_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create developers" do
    setup [:authenticate_owner]
    test "renders developers when data is valid", %{conn: conn, owner: owner} do
      conn = post(conn, Routes.developer_path(conn, :create, owner), developers: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.developer_path(conn, :show, id))

      assert %{
               "id" => id,
               "api_key" => "some api_key",
               "email" => "developer@email.com",
               "name" => "some name",
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, owner: owner} do
      conn = post(conn, Routes.developer_path(conn, :create, owner), developers: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update developers" do
    setup [:authenticate_owner, :create_developer]

    test "renders developers when data is valid", %{
      conn: conn,
      developers: %Developer{id: id} = developers
    } do
      conn =
        put(conn, Routes.developer_path(conn, :update, developers), developers: @update_attrs)

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.developer_path(conn, :show, id))

      assert %{
               "id" => id,
               "api_key" => "some updated api_key",
               "email" => "someupdatedemail@email.com",
               "name" => "some updated name",
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, developers: developers} do
      conn =
        put(conn, Routes.developer_path(conn, :update, developers), developers: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete developers" do
    setup [:authenticate_owner, :create_developer]

    test "deletes chosen developers", %{conn: conn, developers: developers} do
      conn = delete(conn, Routes.developer_path(conn, :delete, developers))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.developer_path(conn, :show, developers))
      end
    end
  end

  defp authenticate_owner(%{conn: conn}) do
    {:ok, owner} = Account.create_owner(@owner_attrs)
    {:ok, token, _claims} = Auth.Guardian.encode_and_sign(owner)
    conn = put_req_header(conn, "authorization", "Bearer "<> token)
    {:ok, conn: conn, owner: owner}
  end

  defp create_developer(%{owner: owner}) do
    developers = fixture(%{owner_id: owner.id})
    %{developers: developers}
  end
end
