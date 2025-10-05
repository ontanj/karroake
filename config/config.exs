# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :karroake,
  ecto_repos: [Karroake.Repo]

# Configures the endpoint
config :karroake, KarroakeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "lf+7bbOo+PvmnFpMQEpcWDT3i2Fat4o/Sl2ypOzRkhq8kftfxT9i/LtZSN1J30JN",
  render_errors: [view: KarroakeWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: Karroake.PubSub

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :karroake, :auth,
  username: "admin",
  password: "admin"

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.12.18",
  default: [
    args: ~w(js/app.js --bundle --target=es2016 --outdir=../priv/static/assets),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
