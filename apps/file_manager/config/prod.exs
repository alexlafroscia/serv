use Mix.Config

data_path = if (System.get_env("SERV_DATA_PATH")) do
  System.get_env("SERV_DATA_PATH")
else
  "/data"
end

config :file_manager, data_path: data_path
