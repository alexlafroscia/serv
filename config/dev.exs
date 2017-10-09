use Mix.Config

config :tapper,
  debug: true,
  system_id: "serv",
  reporter: Tapper.Reporter.Zipkin
config :tapper, Tapper.Reporter.Zipkin,
  collector_url: "http://localhost:9411/api/v1/spans"
