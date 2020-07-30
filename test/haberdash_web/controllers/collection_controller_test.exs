defmodule HaberdashWeb.CollectionControllerTest do
  use HaberdashWeb.ConnCase

  alias Haberdash.Groups
  alias Haberdash.Groups.Collection

  @create_attrs %{
    description: "some description",
    name: "some name"
  }
  @update_attrs %{
    description: "some updated description",
    name: "some updated name"
  }
  @invalid_attrs %{description: nil, name: nil}

  def fixture(:collection) do
    {:ok, collection} = Groups.create_collection(@create_attrs)
    collection
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all collection", %{conn: conn} do
      conn = get(conn, Routes.collection_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create collection" do
    test "renders collection when data is valid", %{conn: conn} do
      conn = post(conn, Routes.collection_path(conn, :create), collection: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.collection_path(conn, :show, id))

      assert %{
               "id" => id,
               "description" => "some description",
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.collection_path(conn, :create), collection: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update collection" do
    setup [:create_collection]

    test "renders collection when data is valid", %{conn: conn, collection: %Collection{id: id} = collection} do
      conn = put(conn, Routes.collection_path(conn, :update, collection), collection: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.collection_path(conn, :show, id))

      assert %{
               "id" => id,
               "description" => "some updated description",
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, collection: collection} do
      conn = put(conn, Routes.collection_path(conn, :update, collection), collection: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete collection" do
    setup [:create_collection]

    test "deletes chosen collection", %{conn: conn, collection: collection} do
      conn = delete(conn, Routes.collection_path(conn, :delete, collection))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.collection_path(conn, :show, collection))
      end
    end
  end

  defp create_collection(_) do
    collection = fixture(:collection)
    %{collection: collection}
  end
end
