defmodule Haberdash.Auth.ErrorHandler do
  require Logger
  import Plug.Conn
  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler

  def auth_error(conn, {type, reason}, _opts) do
    Logger.info("An authentication error has occured type: #{to_string(type)}")

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(:unauthorized, Poison.encode!(%{code: :unauthorized}))
  end
end
