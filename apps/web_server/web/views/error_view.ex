defmodule Serv.WebServer.ErrorView do
  @moduledoc false
  use Serv.WebServer.Web, :view

  def render("404.html", _assigns) do
    "Page not found"
  end

  def render("not_found.json", _assigns) do
    %{
      errors: [

      ]
    }
  end
end
