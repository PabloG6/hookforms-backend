defmodule HaberdashWeb.ProductsController do
  use HaberdashWeb, :controller

  alias Haberdash.Inventory
  alias Haberdash.Inventory.Products

  action_fallback HaberdashWeb.FallbackController

  def index(conn, _params) do
    product = Inventory.list_product()
    render(conn, "index.json", product: product)
  end

  def create(conn, %{"products" => products_params}) do
    with {:ok, %Products{} = products} <- Inventory.create_products(products_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.products_path(conn, :show, products))
      |> render("show.json", products: products)
    end
  end

  def show(conn, %{"id" => id}) do
    products = Inventory.get_products!(id)
    render(conn, "show.json", products: products)
  end

  def update(conn, %{"id" => id, "products" => products_params}) do
    products = Inventory.get_products!(id)

    with {:ok, %Products{} = products} <- Inventory.update_products(products, products_params) do
      render(conn, "show.json", products: products)
    end
  end

  def delete(conn, %{"id" => id}) do
    products = Inventory.get_products!(id)

    with {:ok, %Products{}} <- Inventory.delete_products(products) do
      send_resp(conn, :no_content, "")
    end
  end
end
