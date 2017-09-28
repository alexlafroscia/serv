use Mix.Config

# Override DB config for testing
config :serv, Serv.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "serv_assets_test",
  username: System.get_env("POSTGRES_USER") || "postgres",
  password: System.get_env("POSTGRES_PASSWORD") || "postgres",
  hostname: System.get_env("POSTGRES_HOST") || "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
