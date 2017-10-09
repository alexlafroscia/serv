use Mix.Config

# Configure logger to talk to sidecar container in k8s
config :tapper,
  system_id: "api server",
  reporter: Tapper.Reporter.Zipkin
config :tapper, Tapper.Reporter.Zipkin,
  collector_url: "http://localhost:9411/api/v1/spans"
