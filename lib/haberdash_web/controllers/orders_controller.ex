defmodule HaberdashWeb.OrdersController do
  use HaberdashWeb, :controller

  alias Haberdash.Transactions
  alias Haberdash.Transactions.Orders

  action_fallback HaberdashWeb.FallbackController

  def index(conn, _params) do
    orders = Transactions.list_orders()
    render(conn, "index.json", orders: orders)
  end

  def create(conn, %{"orders" => orders_params}) do
    with {:ok, %Orders{} = orders} <- Transactions.create_orders(orders_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.orders_path(conn, :show, orders))
      |> render("show.json", orders: orders)
    end
  end

  def show(conn, %{"id" => id}) do
    orders = Transactions.get_orders!(id)
    render(conn, "show.json", orders: orders)
  end

  def update(conn, %{"id" => id, "orders" => orders_params}) do
    orders = Transactions.get_orders!(id)

    with {:ok, %Orders{} = orders} <- Transactions.update_orders(orders, orders_params) do
      render(conn, "show.json", orders: orders)
    end
  end

  def delete(conn, %{"id" => id}) do
    orders = Transactions.get_orders!(id)

    with {:ok, %Orders{}} <- Transactions.delete_orders(orders) do
      send_resp(conn, :no_content, "")
    end
  end
end
