defmodule FormsWeb.OwnerController do
  use FormsWeb, :controller

  alias Forms.Accounts
  alias Forms.Accounts.Owner
  alias Forms.Guardian

  action_fallback FormsWeb.FallbackController

  def index(conn, _params) do
    owner = Accounts.list_owner()
    render(conn, "index.json", owner: owner)
  end

  def create(conn,  owner_params) do
    with {:ok, %Owner{} = owner} <- Accounts.create_owner(owner_params),
          {:ok, token, _} <- Guardian.encode_and_sign(owner) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.owner_path(conn, :show, owner))
      |> render("signup.json", owner: owner, token: token)
    end
  end

  def login(conn, %{"email" => email, "password" => password}) do
    with {:ok, owner} <- Accounts.authenticate(email, password) do
      login_reply(conn, owner)
    else
      _error ->
        conn
        |> put_status(:unauthorized)
        |> put_view(FormsWeb.ErrorView)
        |> render(:"401",
          message: "Incorrect user name or password"
        )
    end
  end

  defp login_reply(conn, owner) do

    {:ok, token, _claims} = Guardian.encode_and_sign(owner)
    conn
    |> put_status(:ok)
    |> render(:owner, owner: owner, token: token)
  end

  def show(conn, %{"id" => id}) do
    owner = Accounts.get_owner!(id)
    render(conn, "show.json", owner: owner)
  end

  def update(conn, %{"id" => id, "owner" => owner_params}) do
    owner = Accounts.get_owner!(id)

    with {:ok, %Owner{} = owner} <- Accounts.update_owner(owner, owner_params) do
      render(conn, "show.json", owner: owner)
    end
  end

  def delete(conn, %{"id" => id}) do
    owner = Accounts.get_owner!(id)

    with {:ok, %Owner{}} <- Accounts.delete_owner(owner) do
      send_resp(conn, :no_content, "")
    end
  end
end
