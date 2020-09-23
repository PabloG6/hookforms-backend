use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :haberdash, Haberdash.Repo,
  username: "postgres",
  password: "postgres",
  database: "haberdash_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :haberdash, HaberdashWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only info and wa during test
config :logger, level: :info
config :haberdash,
  folder_name: "test_tmp"
