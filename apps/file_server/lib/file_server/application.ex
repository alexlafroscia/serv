defmodule FileServer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  def start(_type, _args) do
    port =
      if System.get_env("PORT") do
        String.to_integer System.get_env("PORT")
      else
        4001
      end

    # List all child processes to be supervised
    children = [
      Plug.Adapters.Cowboy.child_spec(:http, FileServer.Router, [], [port: port]),
      FileServer.Registry
    ]

    Logger.info "Running FileServer.Router with Cowboy using http://0.0.0.0:#{port}"

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FileServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
