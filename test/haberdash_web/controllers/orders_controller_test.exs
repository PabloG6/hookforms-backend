defmodule HaberdashWeb.OrdersControllerTest do
  use HaberdashWeb.ConnCase
  import Haberdash.Factory
  alias Haberdash.Transactions
  alias Haberdash.Inventory

  alias Haberdash.Transactions.{Orders, OrdersWorker}
  @auth_header "haberdash-api-key"
  @invalid_attrs %{}

  setup %{conn: conn} do
    developer = insert(:developer)
    franchise = insert(:franchise, %{owner_id: developer.owner_id})
    {:ok, pid} = Transactions.OrderSupervisor.start_child(franchise.id)
    accessories = insert(:product, %{franchise_id: franchise.id})
    product = insert(:product, %{franchise_id: franchise.id})

    {:ok,
     conn: put_req_header(conn, "accept", "application/json"),
     product: product,
     developer: developer,
     franchise: franchise,
     accessories: accessories}
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

    test "renders orders when data is valid", %{
      conn: conn,
      product: product,
      accessories: accessories
    } do
      items = %{items: [%{id: "prod_" <> product.id}, %{id: "prod_" <> accessories.id}]}
      conn = post(conn, Routes.orders_path(conn, :create), orders: items)
      assert %{"id" => id} = json_response(conn, 201)["data"]
    end

    test "renders orders with multiple accessories", %{
      conn: conn,
      product: product,
      accessories: accessories,
      franchise: franchise
    } do
    end

    test "renders 404 error when an incorrect id is sent", %{conn: conn} do

    end

    test "renders 401 error when no authentication id is sent", %{product: product} do

    end

    test "renders errors when data is invalid", %{conn: conn} do

    end
  end

  describe "update orders" do
    setup [:init, :create_order]

    test "appends a new order to an existing order", %{conn: conn, product: product, id: id} do


    end

    test "updates the options of an existing order", %{conn: conn, accessories: accessories, product: product, id: id, orders: orders} do

    end

    test "renders errors when data is invalid", %{conn: conn, orders: orders} do

    end
  end

  describe "delete orders" do
    setup [:init, :create_order]
    test "deletes chosen orders", %{conn: conn, orders: orders, api_key: api_key} do


      end

  end

  def create_order(%{product: product, franchise: franchise}) do
    {:ok, pid} = Transactions.OrderRegistry.whereis_name(franchise.id)
    {:ok, %{"id" => id} = orders} = Transactions.OrderWorker.create_order(pid, %{items: [%{id: "prod_" <> product.id}], franchise_id: franchise.id})
    {:ok, id: id, orders: orders}
  end


end
