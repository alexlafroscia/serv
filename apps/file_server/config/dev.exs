use Mix.Config

config :peerage,
  via: Peerage.Via.List,
  node_list: [
    :"admin@127.0.0.1"
  ]
