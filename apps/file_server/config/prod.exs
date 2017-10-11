use Mix.Config

# Allows the file server instances to find the admin node
# on Kubernetes
config :peerage, via: Peerage.Via.Dns,
  dns_name: "epmd-api-server.default.svc.cluster.local",
  app_name: "api-server"
