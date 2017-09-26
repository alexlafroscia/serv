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
    plug Serv.Plug.Authenticate
  end

  scope "/ui", ServWeb do
    pipe_through :browser # Use the default browser stack

    get "/*path", UIController, :index
  end

  scope "/api", ServWeb do
    pipe_through :api

    get "/authenticated", APIController, :check_authenticated
    get "/files", APIController, :index
    get "/files/:file_id", APIController, :show

    patch "/tags/:tag_id/relationships/instance", APITagController, :update_instance
  end

  scope "/", ServWeb do
    get "/", UIController, :redirect_to_index

    post "/upload", FileController, :create
    get "/:file_name", FileController, :show
  end
end
