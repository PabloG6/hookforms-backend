# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :forms,
  ecto_repos: [Forms.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :forms, FormsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "nHb6/vtG7Tzm84tn3L0odfZGRJO+Ce9Plg/hJODO2YbsNYUoRZ+HUTRlxGQjBv/R",
  render_errors: [view: FormsWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Forms.PubSub,
  live_view: [signing_salt: "AoZlWjTy"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :forms, Forms.Guardian,
  issuer: "forms",
  secret_key: "kMLbV8NYWE0cf74XtUQ24nLDDcugKDurINQ+hWkEMrMvw6hIS0V5a6DTlQsxTK4a"
# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
