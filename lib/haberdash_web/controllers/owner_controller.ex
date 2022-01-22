defmodule HaberdashWeb.OwnerController do
  use HaberdashWeb, :controller
  require Logger
  alias Haberdash.{Account, Auth}
  alias Haberdash.Account.Owner

  action_fallback HaberdashWeb.FallbackController

  def index(conn, _params) do
    owner = Account.list_owner()
    render(conn, "index.json", owner: owner)
  end

  @doc """
  returns
  """
  def create(conn, %{"owner" => owner_params}) do
    with {:ok, %Owner{} = owner} <- Account.create_owner(owner_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.owner_path(conn, :show, owner))
      |> render("show.json", owner: owner)
    end
  end

  def login(conn, %{"owner" => %{"email" => email, "password" => password}}) do
    with {:ok, %Owner{} = owner} <- Account.authenticate(email, password) do
      login_reply(conn, owner)
    else
      _ ->
        conn
        |> resp(
          :unauthorized,
          Poison.encode!(%{code: :unauthorized, message: "Invalid email or password."})
        )
        |> send_resp()
    end
  end

  defp login_reply(conn, owner) do
    {:ok, token, _claims} = Auth.Guardian.encode_and_sign(owner)

    conn
    |> put_status(:ok)
    |> render(:owner, owner: owner, token: token)
  end

  def show(conn, %{"id" => id}) do
    owner = Account.get_owner!(id)
    render(conn, "show.json", owner: owner)
  end

  @doc """
  send an invite code to a developer's email.
  """
  def invite(_, _) do
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
