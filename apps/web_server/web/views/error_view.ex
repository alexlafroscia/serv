defmodule Serv.WebServer.ErrorView do
  @moduledoc false
  use Serv.WebServer.Web, :view

  def render("404.html", _assigns) do
    "Page not found"
  end

  def render("404.json", _assigns) do
    %{
      errors: [

      ]
    }
  end

  def render("500.json", _assigns) do
    %{
      errors: [

      ]
    }
  end
end
