defmodule Haberdash.Repo do
  use Ecto.Repo,
    otp_app: :haberdash,
    adapter: Ecto.Adapters.Postgres
end
