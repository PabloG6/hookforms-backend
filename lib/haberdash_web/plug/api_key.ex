defmodule Haberdash.Plug.ApiKey do
  import Plug.Conn
  @auth_header "HaberDash-Api-Key"
  @auth_table_name :haberdash_api_key
  alias Haberdash.{Account, Business}
  alias Haberdash.Repo
  def init(options), do: options

  def call(conn, _opts) do
    conn
    |> authenticate_header()
  end

  defp authenticate_header(%Plug.Conn{} = conn) do
    [head | _tail] = get_req_header(conn, @auth_header)
    # check if header is present in the database.
    with [{_key, {_developer, _owner, _franchise}} | _] <- :ets.lookup(@auth_table_name, head) do
      conn
    else
      _ ->
        # check if api key exists in the database
        with {:ok, developer} <- Account.get_developer(api_key: head) do
          # retrieve the owner as well.
          %Account.Owner{} = owner = Repo.preload(developer, :owner)
          %Business.Franchise{} = franchise = Repo.preload(owner, :franchise)
          :ets.insert(@auth_table_name, {head, {developer, owner, franchise}})
        else
          {:error, :developer_not_found} ->
            conn
            |> resp(
              :not_found,
              Poison.encode!(%{
                code: :key_not_found,
                message:
                  "Api Key is not found, please register a developer account to generate a new api key."
              })
            )
            |> send_resp()
        end
    end
  end
end
