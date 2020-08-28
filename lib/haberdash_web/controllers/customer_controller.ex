defmodule HaberdashWeb.CustomerController do
  use HaberdashWeb, :controller

  alias Haberdash.Account
  alias Haberdash.Account.Customer

  action_fallback HaberdashWeb.FallbackController

  def index(conn, _params) do
    customer = Account.list_customer()
    render(conn, "index.json", customer: customer)
  end

  def create(conn, %{"customer" => customer_params}) do
    with {:ok, %Customer{} = customer} <- Account.create_customer(customer_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.customer_path(conn, :show, customer))
      |> render("show.json", customer: customer)
    end
  end

  def show(conn, %{"id" => id}) do
    customer = Account.get_customer!(id)
    render(conn, "show.json", customer: customer)
  end

  def update(conn, %{"id" => id, "customer" => customer_params}) do
    customer = Account.get_customer!(id)

    with {:ok, %Customer{} = customer} <- Account.update_customer(customer, customer_params) do
      render(conn, "show.json", customer: customer)
    end
  end

  def delete(conn, %{"id" => id}) do
    customer = Account.get_customer!(id)

    with {:ok, %Customer{}} <- Account.delete_customer(customer) do
      send_resp(conn, :no_content, "")
    end
  end
end
