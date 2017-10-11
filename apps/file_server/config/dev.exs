use Mix.Config

config :peerage, via: Peerage.Via.Dns,
  dns_name: "localhost",
  app_name: "api-server"
