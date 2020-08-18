defmodule HaberdashWeb.ProductGroupsController do
  use HaberdashWeb, :controller

  alias Haberdash.Assoc
  alias Haberdash.Assoc.ProductGroups

  action_fallback HaberdashWeb.FallbackController

  def index(conn, _params) do
    product_groups = Assoc.list_product_groups()
    render(conn, "index.json", product_groups: product_groups)
  end

  def create(conn, %{"product_id" => _id, "collection_id" => _collection_id} = params) do
    with {:ok, %ProductGroups{} = product_groups} <- Assoc.create_product_groups(params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.product_groups_path(conn, :show, product_groups))
      |> render("show.json", product_groups: product_groups)
    end
  end

  def show(conn, %{"product_id" => product_id}) do
    product_groups = Assoc.list_product_group_info(product_id)
    
    render(conn, "show.json", product_groups: product_groups)
  end



  def delete(conn, %{"product_id" => product_id, "collection_id" => collection_id}) do
    IO.puts("collection_id #{collection_id}")
    IO.puts "product_id #{product_id}"
   {:ok, product_groups} = Assoc.get_product_groups_by([product_id: product_id, collection_id: collection_id])

    with {:ok, %ProductGroups{}} <- Assoc.delete_product_groups(product_groups) do
      send_resp(conn, :no_content, "")
    end
  end
end
