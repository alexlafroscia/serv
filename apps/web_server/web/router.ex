defmodule Serv.WebServer.Router do
  @moduledoc false
  use Serv.WebServer.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :assets do
  end

  scope "/", Serv.WebServer do
    pipe_through :assets

    get "/:file_name", AssetController, :show
  end

  scope "/api", Serv.WebServer do
    pipe_through :api

    get "/files", FileController, :index
    get "/files/:file_name", FileController, :show
  end
end
