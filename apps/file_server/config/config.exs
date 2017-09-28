# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :tapper,
  system_id: "file server",
  reporter: Tapper.Reporter.Zipkin
config :tapper, Tapper.Reporter.Zipkin,
  collector_url: "http://localhost:9411/api/v1/spans"
