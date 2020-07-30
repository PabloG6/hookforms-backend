defmodule HaberdashWeb.ProductsController do
  use HaberdashWeb, :controller

  alias Haberdash.{Inventory, Business}
  alias Haberdash.Inventory.Products

  action_fallback HaberdashWeb.FallbackController

  def index(conn, _params) do
    %Business.Franchise{} = franchise = conn.private[:franchise]
    IO.inspect franchise
    product = Inventory.list_product(franchise.id)
    render(conn, "index.json", product: product)
  end

  def create(conn, %{"products" => products_params}) do
    %Business.Franchise{} = franchise = conn.private[:franchise]
    with {:ok, %Products{} = products} <- Inventory.create_products(products_params |> Enum.into(%{"franchise_id" => franchise.id})) do
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
    if products.franchise_id != conn.private[:franchise].id do
      conn
      |> resp(:unauthorized, Poison.encode!(%{code: :unauthorized, message: "You are currently unauthorized to modify this product. This means you might "}))
      |> send_resp()
    end
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
