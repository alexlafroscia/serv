defmodule FileServer.Mixfile do
  use Mix.Project

  def project do
    [
      app: :file_server,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :tapper, :peerage, :serv],
      mod: {FileServer.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:cowboy, "~> 1.0"},
      {:plug, "~> 1.4"},
      {:tapper_plug, "~> 0.2"},
      {:peerage, "~> 1.0.2"},
      {:serv, in_umbrella: true}
    ]
  end
end
