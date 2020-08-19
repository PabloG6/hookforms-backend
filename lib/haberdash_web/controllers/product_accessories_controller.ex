defmodule HaberdashWeb.ProductAccessoriesController do
  use HaberdashWeb, :controller

  alias Haberdash.Assoc
  alias Haberdash.Assoc.ProductAccessories

  action_fallback HaberdashWeb.FallbackController

  def index(conn, _params) do
    product_accessories = Assoc.list_product_accessories()
    render(conn, "index.json", product_accessories: product_accessories)
  end

  def create(conn, %{"product_accessories" => product_accessories_params}) do
    with {:ok, %ProductAccessories{} = product_accessories} <- Assoc.create_product_accessories(product_accessories_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.product_accessories_path(conn, :show, product_accessories))
      |> render("show.json", product_accessories: product_accessories)
    end
  end

  def show(conn, %{"id" => id}) do
    product_accessories = Assoc.get_product_accessories!(id)
    render(conn, "show.json", product_accessories: product_accessories)
  end

  def update(conn, %{"id" => id, "product_accessories" => product_accessories_params}) do
    product_accessories = Assoc.get_product_accessories!(id)

    with {:ok, %ProductAccessories{} = product_accessories} <- Assoc.update_product_accessories(product_accessories, product_accessories_params) do
      render(conn, "show.json", product_accessories: product_accessories)
    end
  end

  def delete(conn, %{"id" => id}) do
    product_accessories = Assoc.get_product_accessories!(id)

    with {:ok, %ProductAccessories{}} <- Assoc.delete_product_accessories(product_accessories) do
      send_resp(conn, :no_content, "")
    end
  end
end
