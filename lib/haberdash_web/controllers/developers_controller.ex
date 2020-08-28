defmodule HaberdashWeb.DeveloperController do
  use HaberdashWeb, :controller

  alias Haberdash.Account.Developer
  alias Haberdash.Account
  action_fallback HaberdashWeb.FallbackController

  def index(conn, _params) do
    developer = Account.list_developer()
    render(conn, "index.json", developer: developer)
  end

  def create(conn, %{"id" => id, "developers" => developers_params}) do
    with {:ok, %Developer{} = developers} <- Account.create_developer(developers_params |> Enum.into(%{"owner_id" => id})) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.developer_path(conn, :show, developers))
      |> render("show.json", developers: developers)
    end
  end

  def show(conn, %{"id" => id}) do
    developers = Account.get_developer!(id)
    render(conn, "show.json", developers: developers)
  end

  def update(conn, %{"id" => id, "developers" => developers_params}) do
    developers = Account.get_developer!(id)

    with {:ok, %Developer{} = developers} <-
           Account.update_developer(developers, developers_params) do
      render(conn, "show.json", developers: developers)
    end
  end

  def delete(conn, %{"id" => id}) do
    developers = Account.get_developer!(id)

    with {:ok, %Developer{}} <- Account.delete_developer(developers) do
      send_resp(conn, :no_content, "")
    end
  end
end
