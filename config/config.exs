# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :aldi,
  ecto_repos: [Aldi.Repo]

# Configures the endpoint
config :aldi, AldiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "rVyLbNsiSbaB7CM+bRwZsjwdjJ6PRnvKLls6k4n0DqVXnIcuw2twgX50EaNjBtU6",
  render_errors: [view: AldiWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Aldi.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
