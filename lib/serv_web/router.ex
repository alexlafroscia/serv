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

  scope "/ui", ServWeb do
    pipe_through :browser # Use the default browser stack

    get "/*path", PageController, :index
  end

  scope "/api", ServWeb do
    pipe_through :api

    get "/files", FileController, :index
    get "/files/:file_name", FileController, :show
  end

  scope "/", ServWeb do
    get "/", PageController, :redirect_to_index
    get "/:file_name", AssetController, :show
  end
end