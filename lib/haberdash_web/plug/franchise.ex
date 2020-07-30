defmodule Haberdash.Plug.Franchise do
  import Plug.Conn
  alias Haberdash.{Account, Business, Auth}
  def init(opts), do: opts

  def call(conn, _opts) do
    with %Account.Owner{id: id} <- Auth.Guardian.Plug.current_resource(conn),
         {:ok, franchise} <- Business.get_franchise_by(owner_id: id) do
      conn = put_private(conn, :franchise, franchise)
      conn
    else
      nil ->
        conn
        |> resp(
          :unauthorized,
          Poison.encode!(%{
            code: :unauthorized,
            message:
              "No user found for this token. The token has either expired or the user has been deleted."
          })
        )
        |> send_resp()

      {:error, :not_found} ->
        conn
        |> resp(
          :not_found,
          Poison.encode!(
            code: :franchise_not_found,
            message:
              "No franchise found for this owner, You've either deleted the franchise or never created one to begin with."
          )
        )
    end
  end
end
