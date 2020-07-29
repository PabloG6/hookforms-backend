defmodule HaberdashWeb.OwnerController do
  use HaberdashWeb, :controller
  require Logger
  alias Haberdash.Account
  alias Haberdash.Account.Owner

  action_fallback HaberdashWeb.FallbackController

  def index(conn, _params) do
    owner = Account.list_owner()
    render(conn, "index.json", owner: owner)
  end

  def create(conn, %{"owner" => owner_params}) do
    with {:ok, %Owner{} = owner} <- Account.create_owner(owner_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.owner_path(conn, :show, owner))
      |> render("show.json", owner: owner)
    end
  end

  def show(conn, %{"id" => id}) do
    owner = Account.get_owner!(id)
    render(conn, "show.json", owner: owner)
  end

  def update(conn, %{"id" => id, "owner" => owner_params}) do
    owner = Account.get_owner!(id)
    with {:ok, %Owner{} = owner} <- Account.update_owner(owner, owner_params) do
      render(conn, "show.json", owner: owner)
    end


  end

  def delete(conn, %{"id" => id}) do
    owner = Account.get_owner!(id)

    with {:ok, %Owner{}} <- Account.delete_owner(owner) do
      send_resp(conn, :no_content, "")
    end
  end
end
