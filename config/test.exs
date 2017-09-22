use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :serv, ServWeb.Endpoint,
  http: [port: 4001],
  server: false

config :serv, Serv.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "serv_assets_test",
  username: System.get_env("POSTGRES_USER") || "postgres",
  password: System.get_env("POSTGRES_PASSWORD") || "postgres",
  hostname: System.get_env("POSTGRES_HOST") || "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# Print only warnings and errors during test
config :logger, level: :warn

config :serv,
  data_path: Path.join(System.tmp_dir!, "serv_tests")
