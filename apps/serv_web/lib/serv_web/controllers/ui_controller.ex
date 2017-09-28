defmodule ServWeb.UIController do
  use ServWeb, :controller

  plug :put_view, ServWeb.PageView

  def index(conn, _params) do
    render conn, "index.html",
      layout: false
  end

  def redirect_to_index(conn, _params) do
    Phoenix.Controller.redirect conn, to: "/ui"
  end
end
