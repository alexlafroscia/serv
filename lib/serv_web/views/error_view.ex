defmodule ServWeb.ErrorView do
  @moduledoc false
  use ServWeb, :view

  def render("404.html", _assigns) do
    "Page not found"
  end

  def render("500.html", _assigns) do
    "Internal server error"
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

  def template_not_found(_template, assigns) do
    render "500.html", assigns
  end
end
