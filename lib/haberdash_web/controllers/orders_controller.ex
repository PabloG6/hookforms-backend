defmodule HaberdashWeb.OrdersController do
  use HaberdashWeb, :controller
  alias Haberdash.Transactions
  import Poison
  import Phoenix.LiveView.Controller
  require Logger
  action_fallback HaberdashWeb.FallbackController

  @process_not_found "The existing process that manages your orders seems to be down. Please give us a few minutes to get it back up again."
  @order_created "A session for your customer's order has been created. You can access, modify and update this session with the access id returned to you."
  @order_updated "Your customer's order session has been updated. "

  def index(conn, _params) do
    orders = Transactions.list_orders()
    render(conn, "index.json", orders: orders)
  end


  def create(conn, %{"orders" => orders_params}) do
    franchise = conn.private[:franchise]

    with {:ok, pid} <- Transactions.OrderRegistry.whereis_name(franchise.id),
         {:ok, orders} <-
           Transactions.OrderWorker.create_order(
             pid,
             Map.put(orders_params, "franchise_id", franchise.id)
           ) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(
        :created,
        encode!(%{
          code: :order_created,
          message: @order_created,
          data: orders
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

  # creates a checkout instance, not sure where to go to from here.

  def create(conn, %{"id" => id}) do
    franchise = conn.private[:franchise]
    Logger.info("creating a checkout instance")
    with {:ok, pid} <- Transactions.OrderRegistry.whereis_name(franchise.id),
          {:ok, order} <- Transactions.OrderWorker.show_order(pid, id) do

          live_render(conn, HaberdashWeb.CheckoutLive.Index, session: %{"orders" => order})
          else
            err ->
              Logger.debug("unknown error occured #{inspect(err)}")
              err
    end
  end



  def show(conn, %{"id" => id}) do
    franchise = conn.private[:franchise]
    with {:ok, pid} <- Transactions.OrderRegistry.whereis_name(franchise.id),
         {:ok, order} <- Transactions.OrderWorker.show_order(pid, id) do
          conn
          |> send_resp(:ok, encode!(%{data: order}))
         end
  end

  def patch(conn, %{"id" => id, "orders" => orders_params}) do
    franchise = conn.private[:franchise]

    with {:ok, pid} <- Transactions.OrderRegistry.whereis_name(franchise.id),
         {:ok, updated_orders} <- Transactions.OrderWorker.modify_order(pid, id, orders_params) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(:ok, encode!(%{code: :order_updated, message: @order_updated, data: updated_orders}))
    else
      {:error, :undefined} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(
          :not_found,
          encode!(%{code: :process_not_found, message: @process_not_found}))


    end


  end

  def update(conn, %{"id" => id, "orders" => orders_params}) do
    franchise = conn.private[:franchise]
    with {:ok, pid} <- Transactions.OrderRegistry.whereis_name(franchise.id),
         {:ok, updated_orders} <-
           Transactions.OrderWorker.append_order(
             pid,
             id,
             orders_params
           ) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(
        :ok,
        encode!(%{
          code: :order_updated,
          message: @order_created,
          data: updated_orders
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

  def delete(conn, %{"id" => id}) do
    franchise = conn.private[:franchise]
    with {:ok, pid} <- Transactions.OrderRegistry.whereis_name(franchise.id),
         :ok <- Transactions.OrderWorker.delete_order(pid, id) do
          send_resp(conn, :no_content, "")
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
end
