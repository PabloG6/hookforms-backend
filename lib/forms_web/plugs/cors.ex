defmodule Forms.Cors do
  use Corsica.Router,
    origins: [~r{^https?://(.*\.?)hookforms\.dev}],
    allow_credentials: true,
    log: [rejected: :error],
    allow_headers: :all,
    allow_methods: :all
end
