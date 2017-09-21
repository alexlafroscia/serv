# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :serv, ServWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "5THVluNIoBZ+deSrh8oA9VeF9BuLzLSa7sS3vdxmAwYcOsf+F9Jlp5dFf8nN9me+",
  render_errors: [view: ServWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Serv.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :serv, ecto_repos: [Serv.Repo]
config :serv, Serv.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "serv_assets",
  hostname: "localhost"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure the location to check for stored files
config :serv,
  data_path: "/data",
  password: System.get_env("SERV_PASSWORD")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
