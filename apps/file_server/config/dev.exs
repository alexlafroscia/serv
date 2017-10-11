use Mix.Config

config :peerage, via: Peerage.Via.List,
  node_list: [
    :"api-server@127.0.0.1"
  ]
