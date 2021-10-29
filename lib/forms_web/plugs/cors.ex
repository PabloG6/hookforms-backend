defmodule Forms.Cors do
  use Corsica.Router,
    origins: ["https://hookforms.dev"],
    allow_credentials: true,
    log: [rejected: :error]
end
