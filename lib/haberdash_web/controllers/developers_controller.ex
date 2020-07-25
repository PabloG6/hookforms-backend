defmodule HaberdashWeb.DevelopersController do
  use HaberdashWeb, :controller

  alias Haberdash.Account
  alias Haberdash.Account.Developers

  action_fallback HaberdashWeb.FallbackController

  def index(conn, _params) do
    developer = Account.list_developer()
    render(conn, "index.json", developer: developer)
  end

  def create(conn, %{"developers" => developers_params}) do
    with {:ok, %Developers{} = developers} <- Account.create_developers(developers_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.developers_path(conn, :show, developers))
      |> render("show.json", developers: developers)
    end
  end

  def show(conn, %{"id" => id}) do
    developers = Account.get_developers!(id)
    render(conn, "show.json", developers: developers)
  end

  def update(conn, %{"id" => id, "developers" => developers_params}) do
    developers = Account.get_developers!(id)

    with {:ok, %Developers{} = developers} <- Account.update_developers(developers, developers_params) do
      render(conn, "show.json", developers: developers)
    end
  end

  def delete(conn, %{"id" => id}) do
    developers = Account.get_developers!(id)

    with {:ok, %Developers{}} <- Account.delete_developers(developers) do
      send_resp(conn, :no_content, "")
    end
  end
end
