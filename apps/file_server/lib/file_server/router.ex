defmodule FileServer.Router do
  @moduledoc false

  use Plug.Router

  plug Tapper.Plug.Filter
  plug Tapper.Plug.Trace, tapper: [
    name: "file request"
  ]

  plug Plug.Logger

  plug :match
  plug :dispatch

  match _ do
    FileServer.fetch(conn)
  end
end

