defmodule HaberdashWeb.DevelopersControllerTest do
  use HaberdashWeb.ConnCase

  alias Haberdash.Account
  alias Haberdash.Account.Developers

  @create_attrs %{
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

  def fixture(:developers) do
    {:ok, developers} = Account.create_developers(@create_attrs)
    developers
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all developer", %{conn: conn} do
      conn = get(conn, Routes.developers_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create developers" do
    test "renders developers when data is valid", %{conn: conn} do
      conn = post(conn, Routes.developers_path(conn, :create), developers: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.developers_path(conn, :show, id))

      assert %{
               "id" => id,
               "api_key" => "some api_key",
               "email" => "some email",
               "name" => "some name",
               "password_hash" => "some password_hash"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.developers_path(conn, :create), developers: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update developers" do
    setup [:create_developers]

    test "renders developers when data is valid", %{conn: conn, developers: %Developers{id: id} = developers} do
      conn = put(conn, Routes.developers_path(conn, :update, developers), developers: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.developers_path(conn, :show, id))

      assert %{
               "id" => id,
               "api_key" => "some updated api_key",
               "email" => "some updated email",
               "name" => "some updated name",
               "password_hash" => "some updated password_hash"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, developers: developers} do
      conn = put(conn, Routes.developers_path(conn, :update, developers), developers: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete developers" do
    setup [:create_developers]

    test "deletes chosen developers", %{conn: conn, developers: developers} do
      conn = delete(conn, Routes.developers_path(conn, :delete, developers))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.developers_path(conn, :show, developers))
      end
    end
  end

  defp create_developers(_) do
    developers = fixture(:developers)
    %{developers: developers}
  end
end
