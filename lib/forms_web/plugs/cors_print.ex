defmodule Forms.CorsPrint do
  import Plug.Conn
  require Logger

  def init(options), do: options

  def call(conn, _opts) do
    Logger.info("hello world #{inspect(conn)}")
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "Hello World!\n")
  end
end
