defmodule HaberdashWeb.ApiKeyController do
  use HaberdashWeb, :controller

  alias Haberdash.Auth
  alias Haberdash.Auth.ApiKey

  action_fallback HaberdashWeb.FallbackController

  def index(conn, %{"id" => id}) do
    api_key = Auth.list_api_key(id)
    render(conn, "index.json", api_key: api_key)
  end

  def create(conn, %{"api_key" => api_key_params}) do
    with {:ok, %ApiKey{} = api_key} <- Auth.create_api_key(api_key_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.api_key_path(conn, :show, api_key))
      |> render("show.json", api_key: api_key)
    end
  end

  def show(conn, %{"id" => id}) do
    api_key = Auth.get_api_key!(id)
    render(conn, "show.json", api_key: api_key)
  end

  def update(conn, %{"id" => id, "api_key" => api_key_params}) do
    api_key = Auth.get_api_key!(id)

    with {:ok, %ApiKey{} = api_key} <- Auth.update_api_key(api_key, api_key_params) do
      render(conn, "show.json", api_key: api_key)
    end
  end

  def delete(conn, %{"id" => id}) do
    api_key = Auth.get_api_key!(id)

    with {:ok, %ApiKey{}} <- Auth.delete_api_key(api_key) do
      send_resp(conn, :no_content, "")
    end
  end
end
