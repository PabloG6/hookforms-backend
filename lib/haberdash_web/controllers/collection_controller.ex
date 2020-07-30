defmodule HaberdashWeb.CollectionController do
  use HaberdashWeb, :controller

  alias Haberdash.Groups
  alias Haberdash.Groups.Collection

  action_fallback HaberdashWeb.FallbackController

  def index(conn, _params) do
    collection = Groups.list_collection()
    render(conn, "index.json", collection: collection)
  end

  def create(conn, %{"collection" => collection_params}) do
    with {:ok, %Collection{} = collection} <- Groups.create_collection(collection_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.collection_path(conn, :show, collection))
      |> render("show.json", collection: collection)
    end
  end

  def show(conn, %{"id" => id}) do
    collection = Groups.get_collection!(id)
    render(conn, "show.json", collection: collection)
  end

  def update(conn, %{"id" => id, "collection" => collection_params}) do
    collection = Groups.get_collection!(id)

    with {:ok, %Collection{} = collection} <- Groups.update_collection(collection, collection_params) do
      render(conn, "show.json", collection: collection)
    end
  end

  def delete(conn, %{"id" => id}) do
    collection = Groups.get_collection!(id)

    with {:ok, %Collection{}} <- Groups.delete_collection(collection) do
      send_resp(conn, :no_content, "")
    end
  end
end
