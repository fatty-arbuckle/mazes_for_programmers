# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :mazes_for_programmers,
  ecto_repos: [MazesForProgrammers.Repo]

# Configures the endpoint
config :mazes_for_programmers, MazesForProgrammers.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "zJonJ/UJOhu+4x3AybUVpgQK3QXZa8NnHSF76IJgq5ou9X2xJMy675WzP99Ce5PY",
  render_errors: [view: MazesForProgrammers.ErrorView, accepts: ~w(html json)],
  pubsub: [name: MazesForProgrammers.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
