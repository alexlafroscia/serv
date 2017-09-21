use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :serv, ServWeb.Endpoint,
  http: [port: 4001],
  server: false

config :serv, Serv.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "serv_assets_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# Print only warnings and errors during test
config :logger, level: :warn

config :serv,
  data_path: Path.join(System.tmp_dir!, "serv_tests")
