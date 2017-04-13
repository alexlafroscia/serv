use Mix.Config

# Configure the location to check for stored files
config :file_manager, data_path: "/data"

import_config "#{Mix.env}.exs"
