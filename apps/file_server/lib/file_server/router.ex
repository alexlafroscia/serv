defmodule FileServer.Router do
  @moduledoc false

  use Plug.Router

  plug Tapper.Plug.Filter
  plug Tapper.Plug.Trace,
    debug: Application.get_env(:tapper, :debug, false),
    tapper: [
      name: "file-server"
    ]

  plug Plug.Logger

  plug :match
  plug :dispatch

  match _ do
    FileServer.fetch(conn)
  end
end

