defmodule HaberdashWeb.OrdersController do
  use HaberdashWeb, :controller
  alias Haberdash.Transactions
  alias Haberdash.Transactions.Orders
  import Poison
  action_fallback HaberdashWeb.FallbackController

  @process_not_found "The existing process that manages your orders seems to be down. Please give us a few minutes to get it back up again."
  @order_instance_created "A session for your customer's order has been created. You can access, modify and update this session with the access id returned to you."

  def index(conn, _params) do
    orders = Transactions.list_orders()
    render(conn, "index.json", orders: orders)
  end

  def create(conn, %{"orders" => orders_params}) do
    franchise = conn.private[:franchise]

    with {:ok, pid} <- Transactions.OrderRegistry.whereis_name(franchise.id),
         {:ok, order_list} <-
           Transactions.OrdersWorker.create_order(
             pid,
             Map.put(orders_params, "franchise_id", franchise.id)
           ) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(
        :created,
        encode!(%{
          code: :order_instance_created,
          message: @order_instance_created,
          data: order_list
        })
      )
    else
      {:error, :undefined} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(
          :not_found,
          encode!(%{code: :process_not_found, message: @process_not_found})
        )
    end
  end

  def create(conn, %{"id" => order_id, "orders" => orders_params}) do
    franchise = conn.private[:franchise]

    with {:ok, pid} <- Transactions.OrderRegistry.whereis_name(franchise.id),
         {:ok, order_list} <-
           Transactions.OrdersWorker.update_order(
             pid,
             order_id,
             orders_params
           ) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(
        :created,
        encode!(%{
          code: :order_instance_created,
          message: @order_instance_created,
          data: order_list
        })
      )
    else
      {:error, :undefined} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(
          :not_found,
          encode!(%{code: :process_not_found, message: @process_not_found})
        )
    end
  end



  def show(conn, %{"id" => id}) do
    orders = Transactions.get_orders!(id)
    render(conn, "show.json", orders: orders)
  end

  def update(conn, %{"id" => id, "orders" => orders_params}) do
    franchise = conn.private[:franchise]

    with {:ok, pid} <- Transactions.OrderRegistry.whereis_name(franchise.id),
         {:ok, _} <- Transactions.OrdersWorker.update_order(pid, id, orders_params) do
      conn
      |> put_status(:created)
    end
  end

  def delete(conn, %{"id" => id}) do
    orders = Transactions.get_orders!(id)

    with {:ok, %Orders{}} <- Transactions.delete_orders(orders) do
      send_resp(conn, :no_content, "")
    end
  end
end
