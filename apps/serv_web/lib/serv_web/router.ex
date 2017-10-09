defmodule ServWeb.Router do
  use ServWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticate do
    plug ServWeb.Plug.Authenticate
  end

  scope "/api", ServWeb do
    pipe_through :api
    pipe_through :authenticate

    get "/authenticated", APIController, :check_authenticated
    get "/files", APIController, :index
    get "/files/:file_id", APIController, :show

    patch "/tags/:tag_id/relationships/instance", APITagController, :update_instance
  end

  scope "/upload", ServWeb do
    pipe_through :authenticate

    post "/", FileController, :create
  end

  scope "/", ServWeb do
    pipe_through :browser

    get "/*path", UIController, :index
  end
end
