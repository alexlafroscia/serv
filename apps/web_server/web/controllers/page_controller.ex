defmodule Serv.WebServer.PageController do
  use Serv.WebServer.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
