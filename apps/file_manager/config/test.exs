use Mix.Config

config :file_manager,
  data_path: Path.join(System.tmp_dir!, "serv_tests")
