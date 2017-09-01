defmodule ServWeb.PageController do
  use ServWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def redirect_to_index(conn, _params) do
    Phoenix.Controller.redirect conn, to: "/ui"
  end
end
