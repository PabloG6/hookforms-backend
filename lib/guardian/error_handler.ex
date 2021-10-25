defmodule Forms.Auth.ErrorHandler do
  import Plug.Conn

  @behaviour Guardian.Plug.ErrorHandler
  @impl Guardian.Plug.ErrorHandler
  require Logger
  def auth_error(conn, {type, reason}, _opts) do
    body = Poison.encode!(%{message: to_string(inspect(type))})
    Logger.error("#{inspect(reason)} #{inspect(type)}")
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, body)
  end
end
