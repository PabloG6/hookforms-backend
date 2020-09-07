defmodule HaberdashWeb.OrdersControllerTest do
  use HaberdashWeb.ConnCase
  import Haberdash.Factory
  alias Haberdash.Transactions
  alias Haberdash.Inventory

  alias Haberdash.Transactions.Orders
  @auth_header "haberdash-api-key"
  @create_attrs %{
    customer_id: "some customer_id",
    drop_off_address: "some drop_off_address",
    drop_off_location: [],
    franchise_id: "some franchise_id",
    items: []
  }
  @update_attrs %{
    customer_id: "some updated customer_id",
    drop_off_address: "some updated drop_off_address",
    drop_off_location: [],
    franchise_id: "some updated franchise_id",
    items: []
  }
  @invalid_attrs %{customer_id: nil, drop_off_address: nil, drop_off_location: nil, franchise_id: nil, items: nil}

  def fixture(:orders) do
    {:ok, orders} = Transactions.create_orders(@create_attrs)
    orders
  end



  setup %{conn: conn} do
    developer = insert(:developer)
    franchise = insert(:franchise, %{owner_id: developer.owner_id})
    {:ok, pid} = Transactions.OrderSupervisor.start_child(franchise.id)
    accessories = insert(:accessories, %{franchise_id: franchise.id})
    product = insert(:product, %{franchise_id: franchise.id})
    {:ok, conn: put_req_header(conn, "accept", "application/json"),
     product: product, developer: developer, franchise: franchise, accessories: accessories}
  end

  def init(%{conn: conn, developer: developer}) do
    api_key = insert(:apikey, %{developer_id: developer.id})
    conn = put_req_header(conn, @auth_header, api_key.api_key)
    {:ok, api_key: api_key, conn: conn}

  end

  describe "index" do
    setup [:init]
    test "lists all orders", %{conn: conn} do
      conn = get(conn, Routes.orders_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create orders" do
    setup [:init]
    test "renders orders when data is valid", %{conn: conn, product: product, accessories: accessories} do
      items = %{items: [%{item_id: product.id, item_type: :products}, %{item_id: accessories.id, item_type: :accessories}]}
      conn = post(conn, Routes.orders_path(conn, :create), orders: items)
      IO.inspect json_response(conn, 201)["data"]
      assert %{"id" => id} = json_response(conn, 201)["data"]
    end

    test "renders orders with multiple accessories", %{conn: conn, product: product, accessories: accessories} do
      product_accessories = insert(:product_accessories, %{product_id: product.id, accessories_id: accessories.id})
      items = %{items: [%{id: "prod_" <> product.id, accessories: [%{id:  "acc_" <> product_accessories.accessories_id}]}, %{id: "acc_" <> accessories.id}]}
      conn = post(conn, Routes.orders_path(conn, :create), orders: items)
      IO.inspect json_response(conn, 201)["data"]

    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.orders_path(conn, :create), orders: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update orders" do
    setup [:create_orders]

    test "renders orders when data is valid", %{conn: conn, orders: %Orders{id: id} = orders} do
      conn = put(conn, Routes.orders_path(conn, :update, orders), orders: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.orders_path(conn, :show, id))

      assert %{
               "id" => id,
               "customer_id" => "some updated customer_id",
               "drop_off_address" => "some updated drop_off_address",
               "drop_off_location" => [],
               "franchise_id" => "some updated franchise_id",
               "items" => []
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, orders: orders} do
      conn = put(conn, Routes.orders_path(conn, :update, orders), orders: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete orders" do
    setup [:create_orders]

    test "deletes chosen orders", %{conn: conn, orders: orders} do
      conn = delete(conn, Routes.orders_path(conn, :delete, orders))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.orders_path(conn, :show, orders))
      end
    end
  end

  defp create_orders(_) do
    orders = fixture(:orders)
    %{orders: orders}
  end
end
