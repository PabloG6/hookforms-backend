defmodule Haberdash.Plug.ApiKeyFranchise do
  import Plug.Conn
  alias Haberdash.Business
  def init(opts), do: opts

  def call(conn, _) do
    developer = conn.private[:api_key_developer]
    IO.inspect developer
    {:ok, franchise} = Business.get_franchise_by(owner_id: developer.owner_id)
    put_private(conn, :franchise, franchise)
  end
end
