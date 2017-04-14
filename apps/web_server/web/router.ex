defmodule Serv.WebServer.Router do
  @moduledoc false
  use Serv.WebServer.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end


  end
end
