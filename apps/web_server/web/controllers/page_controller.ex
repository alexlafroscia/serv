defmodule Serv.WebServer.PageController do
  @moduledoc false
  use Serv.WebServer.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
