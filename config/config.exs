# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :karroake,
  ecto_repos: [Karroake.Repo]

# Configures the endpoint
config :karroake, KarroakeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "lf+7bbOo+PvmnFpMQEpcWDT3i2Fat4o/Sl2ypOzRkhq8kftfxT9i/LtZSN1J30JN",
  render_errors: [view: KarroakeWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Karroake.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
