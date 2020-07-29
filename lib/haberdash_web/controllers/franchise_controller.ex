defmodule HaberdashWeb.FranchiseController do
  use HaberdashWeb, :controller

  alias Haberdash.Business
  alias Haberdash.Business.Franchise
  alias Haberdash.{Auth, Account.Owner}
  action_fallback HaberdashWeb.FallbackController

  def index(conn, _params) do
    franchise = Business.list_franchises()
    render(conn, "index.json", franchise: franchise)
  end

  def create(conn, %{"franchise" => franchise_params}) do
    with %Owner{id: id} <- Auth.Guardian.Plug.current_resource(conn),
         {:ok, %Franchise{} = franchise} <- Business.create_franchise(franchise_params |> Enum.into(%{"owner_id" => id})) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.franchise_path(conn, :show, franchise))
      |> render("show.json", franchise: franchise)
    end
  end


  def show(conn, _params) do
    with %Owner{id: id} <- Auth.Guardian.Plug.current_resource(conn),
         {:ok, %Franchise{} = franchise} <- Business.get_franchise_by(owner_id: id) do
          render(conn, "show.json", franchise: franchise)
    else
      nil ->
          conn
          |> resp(
            :unauthorized,
            Poison.encode!(%{
              code: :unauthorized,
              message:
                "You aren't authorized to access this route. This may be because you aren't currently logged in or your session expired due to inactivity. "
            })
          ) |> send_resp()
      {:error, :not_found} ->
        {:error, :not_found}
        error ->
          error



    end


  end

  def update(conn, %{"franchise" => franchise_params}) do
    %Owner{id: id} = owner = Auth.Guardian.Plug.current_resource(conn)
    {:ok, franchise} = Business.get_franchise_by(owner_id: id)
    with {:ok, %Franchise{} = franchise} <- Business.update_franchise(franchise, franchise_params) do
      render(conn, "show.json", franchise: franchise)
    else
      error ->
        error
    end
  end

  def delete(conn, %{"id" => id}) do
    franchise = Business.get_franchise!(id)

    with {:ok, %Franchise{}} <- Business.delete_franchise(franchise) do
      send_resp(conn, :no_content, "")
    end
  end
end
