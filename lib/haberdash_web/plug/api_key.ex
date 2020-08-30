defmodule Haberdash.Plug.ApiKey do
  import Plug.Conn
  @auth_header "Haberdash-Api-Key"
  alias Haberdash.{Account, Auth}
  use Haberdash.Messages
  def init(options), do: options

  def call(conn, _opts) do
    conn
    |> authenticate_header()
  end

  defp authenticate_header(%Plug.Conn{} = conn) do
    with [key | _] <- get_req_header(conn, @auth_header),
          {:ok, _} <- get_resource(key) do
            conn
          else
            {:error, :not_found} ->
              get_resource(conn)
            _ ->
              conn



    end
  end

  defp get_resource(id) when is_binary(id) do
    case Auth.Cache.get(id) do
      nil ->
        {:error, :not_found}
      %Auth.ApiKey{} = api_key ->
        {:ok, api_key }
    end
  end

  defp get_resource(%Plug.Conn{} = conn) do
    [id | _] = get_req_header(conn, @auth_header)
    developer = Account.get_developer!(id)
    {:ok, developer}
  rescue
    Ecto.NoResultsError ->
      conn
      |> send_resp(:unauthorized, Poison.encode!(%{code: :unauthorized, message: @unauthorized_key}))
  end
end
