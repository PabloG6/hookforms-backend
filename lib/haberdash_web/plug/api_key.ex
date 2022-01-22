defmodule Haberdash.Plug.ApiKey do
  import Plug.Conn
  @auth_header "haberdash-api-key"
  alias Haberdash.{Account, Auth}
  use Haberdash.Messages
  require Logger

  import Poison
  def init(options), do: options

  def call(conn, _opts) do
    conn
    |> authenticate_header()
  end

  defp authenticate_header(%Plug.Conn{} = conn) do
    with [key | _] <- get_req_header(conn, @auth_header),
         {:ok, {developer, _}} <- get_resource(key) do
      conn |> put_private(:api_key_developer, developer)
    else
      {:error, :not_found} ->
        get_resource(conn)

      error ->
        Logger.info("An error occured in api key plug")
        IO.inspect(error)

        conn
        |> send_resp(:unauthorized, encode!(%{code: :unauthorized}))
    end
  end

  defp get_resource(id) when is_binary(id) do
    case Auth.Cache.get(id) do
      nil ->
        {:error, :not_found}

      {%Account.Developer{}, %Auth.ApiKey{}} = data ->
        {:ok, data}
    end
  end

  defp get_resource(%Plug.Conn{} = conn) do
    [id | _] = get_req_header(conn, @auth_header)
    # Use get_developer because it's already caching the data.
    Logger.info("Key not present in cache searching the database")
    api_key = Auth.get_api_key_by!(id)
    developer = Account.get_developer!(api_key.developer_id)

    :ok = Auth.Cache.put(id, {developer, api_key}, ttl: :timer.minutes(10))
    put_private(conn, :api_key_developer, developer)
  rescue
    Ecto.NoResultsError ->
      conn
      |> send_resp(
        :unauthorized,
        Poison.encode!(%{code: :unauthorized, message: @unauthorized_key})
      )
  end
end
