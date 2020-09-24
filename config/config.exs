# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :haberdash,
  ecto_repos: [Haberdash.Repo]

# Configures the endpoint
config :haberdash, HaberdashWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "mJsHXCFcI0wCZtebwni4t21wm5kjWDidzF7KWX+CNek39+eG516CVy0aaP32N5QW",
  render_errors: [view: HaberdashWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Haberdash.PubSub,
  live_view: [signing_salt: "2MRU2xbZ"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Config Guardian
config :haberdash, Haberdash.Auth.Guardian,
  issuer: "haberdash",
  secret_key: "25GBxhh00vzTHFanitmpfXegn4EkdSt0kJv6XKw/LPDV29IqapXKmIZApvXJ+qeh"

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason
config :bcrypt_elixir, log_rounds: 4
config :google_maps, api_key: "AIzaSyC5nmClPzAlixLVy1rEY4PwHsx7ebQzMjw"



# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
