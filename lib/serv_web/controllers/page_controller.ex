defmodule ServWeb.PageController do
  use ServWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
