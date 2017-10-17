# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :serv_web,
  namespace: ServWeb,
  password: System.get_env("SERV_PASSWORD"),
  file_server_host: System.get_env("FILE_SERVER_HOST") || "localhost:4001"

# Configures the endpoint
config :serv_web, ServWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "+FSq5TYzo+ClEH2TAIanAzbO/+GAhyxYSdIvxYkJESHM1EzmxIPi7aEWxkLKfsUD",
  render_errors: [view: ServWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ServWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :serv_web, :generators,
  context_app: false

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
