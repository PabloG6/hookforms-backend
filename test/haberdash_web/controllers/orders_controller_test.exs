defmodule HaberdashWeb.OrdersControllerTest do
  use HaberdashWeb.ConnCase
  import Haberdash.Factory
  alias Haberdash.Transactions
  alias Haberdash.Inventory

  alias Haberdash.Transactions.Orders
  @auth_header "haberdash-api-key"


  setup %{conn: conn} do
    developer = insert(:developer)
    franchise = insert(:franchise, %{owner_id: developer.owner_id})
    {:ok, pid} = Transactions.OrderSupervisor.start_child(franchise.id)
    accessories = insert(:accessories, %{franchise_id: franchise.id})
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
      items = %{items: [%{id: "prod_" <> product.id}, %{id: "acc_" <> accessories.id}]}
      conn = post(conn, Routes.orders_path(conn, :create), orders: items)
      assert %{"id" => id, "total" => total} = json_response(conn, 201)["data"]
      assert total == accessories.price + product.price

    end

    test "renders orders with multiple accessories", %{
      conn: conn,
      product: product,
      accessories: accessories,
      franchise: franchise
    } do
      product_accessories =
        insert(:product_accessories, %{product_id: product.id, accessories_id: accessories.id})

      items = %{
        items: [
          %{
            id: "prod_" <> product.id,
            accessories: [%{id: "acc_" <> product_accessories.accessories_id}]
          },
          %{id: "acc_" <> accessories.id}
        ]
      }

      conn = post(conn, Routes.orders_path(conn, :create), orders: items)
      %{id: franchise_id} = franchise

      assert %{"id" => id, "franchise_id" => franchise_id, "items" => items} =
               json_response(conn, 201)["data"]

      %{name: product_name, description: product_description} = product

      assert %{
               "accessories" => acc_list,
               "name" => product_name,
               "description" => product_description,
               "franchise_id" => franchise_id
             } = Enum.at(items, 0)
    end

    test "renders 404 error when an incorrect id is sent", %{conn: conn} do
      items = %{items: [%{id: "prod_" <> Ecto.UUID.generate()}]}

      assert_error_sent 404, fn ->
        post(conn, Routes.orders_path(conn, :create), orders: items)
      end
    end

    test "renders 401 error when no authentication id is sent", %{product: product} do
      items = %{items: [%{id: "prod_" <> product.id}]}
      conn = build_conn()

      assert_error_sent 401, fn ->
        post(conn, Routes.orders_path(conn, :create), orders: items)
      end
    end

    test "renders errors when data is invalid", %{conn: conn} do
      assert_error_sent 500, fn ->
        post(conn, Routes.orders_path(conn, :create), orders: %{})
      end
    end
  end

  describe "update orders" do
    setup [:init, :create_order]

    test "appends a new order to an existing order", %{conn: conn, product: product, orders: %{"id" => id}} do

      conn =
        put(conn, Routes.orders_path(conn, :create, id),
          orders: %{items: [%{id: "prod_" <> product.id}]}
        )

      assert %{"id" => ^id, "items" => items} = json_response(conn, 200)["data"]
      assert length(items) == 2
    end

    test "updates the options of an existing order", %{conn: conn, accessories: accessories, product: product, orders: orders} do

        %{"items" => [first_order | _]} = orders
        conn = patch(conn, Routes.orders_path(conn, :update, orders["id"]), orders: %{items: [%{id: first_order["id"] , accessories: [%{id: "acc_" <> accessories.id}]}]})
        assert %{"total" => total} =  json_response(conn, 200)["data"]
        assert total == product.price + accessories.price


    end



    test "renders errors when data is invalid", %{conn: conn, orders: %{"id" => id}} do
      assert_error_sent 500, fn ->
        conn = put(conn, Routes.orders_path(conn, :update, id), orders: %{})
        IO.puts("HELLO WORLD LMFAOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO ---------------------> #{inspect(json_response(conn, 500))}")
      end
    end
  end

  describe "delete orders" do
    setup [:init, :create_order]
    test "deletes chosen orders", %{conn: conn, orders: %{"id" => id}} do
      conn = delete(conn, Routes.orders_path(conn, :delete, id))
      assert response(conn, 204)

      assert_error_sent 401, fn ->
        get(conn, Routes.orders_path(conn, :show, id))
      end
    end
  end

  def create_order(%{product: product, franchise: franchise}) do
    {:ok, pid} = Transactions.OrderRegistry.whereis_name(franchise.id)
    {:ok, %{"id" => id} = orders} = Transactions.OrderWorker.create_order(pid, %{items: [%{id: "prod_" <> product.id}], franchise_id: franchise.id})
    {:ok, orders: orders}
  end
end
