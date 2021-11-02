defmodule Forms.Cors do
  use Corsica.Router,
    origins: Application.get_env(:forms, :origin),
    allow_credentials: true,
    log: [rejected: :error],
    allow_headers: :all,
    allow_methods: :all,
    max_age: 2000

  resource "/*",
    origins: Application.get_env(:forms, :origin),
    allow_headers: :all,
    allow_methods: :all,
    allow_credentials: true
end
