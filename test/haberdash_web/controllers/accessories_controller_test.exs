defmodule HaberdashWeb.AccessoriesControllerTest do
  use HaberdashWeb.ConnCase

  alias Haberdash.Inventory
  alias Haberdash.Inventory.Accessories

  @create_attrs %{
    franchise: "7488a646-e31f-11e4-aace-600308960662",
    price: 42,
    title: "some title"
  }
  @update_attrs %{
    franchise: "7488a646-e31f-11e4-aace-600308960668",
    price: 43,
    title: "some updated title"
  }
  @invalid_attrs %{franchise: nil, price: nil, title: nil}

  def fixture(:accessories) do
    {:ok, accessories} = Inventory.create_accessories(@create_attrs)
    accessories
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all accessories", %{conn: conn} do
      conn = get(conn, Routes.accessories_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create accessories" do
    test "renders accessories when data is valid", %{conn: conn} do
      conn = post(conn, Routes.accessories_path(conn, :create), accessories: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.accessories_path(conn, :show, id))

      assert %{
               "id" => id,
               "franchise" => "7488a646-e31f-11e4-aace-600308960662",
               "price" => 42,
               "title" => "some title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.accessories_path(conn, :create), accessories: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update accessories" do
    setup [:create_accessories]

    test "renders accessories when data is valid", %{conn: conn, accessories: %Accessories{id: id} = accessories} do
      conn = put(conn, Routes.accessories_path(conn, :update, accessories), accessories: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.accessories_path(conn, :show, id))

      assert %{
               "id" => id,
               "franchise" => "7488a646-e31f-11e4-aace-600308960668",
               "price" => 43,
               "title" => "some updated title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, accessories: accessories} do
      conn = put(conn, Routes.accessories_path(conn, :update, accessories), accessories: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete accessories" do
    setup [:create_accessories]

    test "deletes chosen accessories", %{conn: conn, accessories: accessories} do
      conn = delete(conn, Routes.accessories_path(conn, :delete, accessories))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.accessories_path(conn, :show, accessories))
      end
    end
  end

  defp create_accessories(_) do
    accessories = fixture(:accessories)
    %{accessories: accessories}
  end
end
