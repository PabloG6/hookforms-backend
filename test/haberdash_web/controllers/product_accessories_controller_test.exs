defmodule HaberdashWeb.ProductAccessoriesControllerTest do
  use HaberdashWeb.ConnCase

  alias Haberdash.Assoc
  alias Haberdash.Assoc.ProductAccessories

  @create_attrs %{
    accessories_id: "7488a646-e31f-11e4-aace-600308960662",
    product_id: "7488a646-e31f-11e4-aace-600308960662"
  }
  @update_attrs %{
    accessories_id: "7488a646-e31f-11e4-aace-600308960668",
    product_id: "7488a646-e31f-11e4-aace-600308960668"
  }
  @invalid_attrs %{accessories_id: nil, product_id: nil}

  def fixture(:product_accessories) do
    {:ok, product_accessories} = Assoc.create_product_accessories(@create_attrs)
    product_accessories
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all product_accessories", %{conn: conn} do
      conn = get(conn, Routes.product_accessories_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create product_accessories" do
    test "renders product_accessories when data is valid", %{conn: conn} do
      conn = post(conn, Routes.product_accessories_path(conn, :create), product_accessories: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.product_accessories_path(conn, :show, id))

      assert %{
               "id" => id,
               "accessories_id" => "7488a646-e31f-11e4-aace-600308960662",
               "product_id" => "7488a646-e31f-11e4-aace-600308960662"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.product_accessories_path(conn, :create), product_accessories: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update product_accessories" do
    setup [:create_product_accessories]

    test "renders product_accessories when data is valid", %{conn: conn, product_accessories: %ProductAccessories{id: id} = product_accessories} do
      conn = put(conn, Routes.product_accessories_path(conn, :update, product_accessories), product_accessories: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.product_accessories_path(conn, :show, id))

      assert %{
               "id" => id,
               "accessories_id" => "7488a646-e31f-11e4-aace-600308960668",
               "product_id" => "7488a646-e31f-11e4-aace-600308960668"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, product_accessories: product_accessories} do
      conn = put(conn, Routes.product_accessories_path(conn, :update, product_accessories), product_accessories: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete product_accessories" do
    setup [:create_product_accessories]

    test "deletes chosen product_accessories", %{conn: conn, product_accessories: product_accessories} do
      conn = delete(conn, Routes.product_accessories_path(conn, :delete, product_accessories))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.product_accessories_path(conn, :show, product_accessories))
      end
    end
  end

  defp create_product_accessories(_) do
    product_accessories = fixture(:product_accessories)
    %{product_accessories: product_accessories}
  end
end
