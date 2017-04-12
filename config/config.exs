use Mix.Config

# Configure the location to check for stored files
config :serv, data_path: "/data"

import_config "#{Mix.env}.exs"
