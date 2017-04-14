# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :web_server,
  namespace: Serv.WebServer

# Configures the endpoint
config :web_server, Serv.WebServer.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "uPZWArBflK8zSwA6XHDgS6+UWdxXC2C/fqWf/vamuTvfQmxpPSdyDV+5NYK9AfE9",
  render_errors: [view: Serv.WebServer.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Serv.WebServer.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
