defmodule HaberdashWeb.ProductGroupsController do
  use HaberdashWeb, :controller

  alias Haberdash.Assoc
  alias Haberdash.Assoc.ProductGroups

  action_fallback HaberdashWeb.FallbackController

  def index(conn, _params) do
    product_groups = Assoc.list_product_groups()
    render(conn, "index.json", product_groups: product_groups)
  end

  def create(conn, %{"product_groups" => params}) do
    with {:ok, %ProductGroups{} = product_groups} <- Assoc.create_product_groups(params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.product_groups_path(conn, :show, product_groups))
      |> render("show.json", product_groups: product_groups)
    end
  end

  def show(conn, %{"id" => id}) do
    product_groups = Assoc.get_product_groups!(id)

    render(conn, "show.json", product_groups: product_groups)
  end



  def delete(conn, %{"id" => id}) do

    product_groups = Assoc.get_product_groups!(id)
    IO.inspect product_groups
    with {:ok, %ProductGroups{}} <- Assoc.delete_product_groups(product_groups) do
      send_resp(conn, :no_content, "")

    end
  rescue
    Ecto.NoResultsError
      -> conn
         |> send_resp(:not_found, Poison.encode!(%{code: :not_found, message: "No association found with this id. "}))
  end
end
