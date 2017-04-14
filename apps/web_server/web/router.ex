defmodule Serv.WebServer.Router do
  @moduledoc false
  use Serv.WebServer.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Serv.WebServer do
    pipe_through :api

    get "/files", FileController, :index
    get "/files/:file_name", FileController, :show
  end
end
