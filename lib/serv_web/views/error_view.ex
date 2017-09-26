defmodule ServWeb.ErrorView do
  @moduledoc false
  use ServWeb, :view

  def render("404.html", _assigns) do
    "Page not found"
  end

  def render("500.html", _assigns) do
    "Internal server error"
  end

  def render("404.json", assigns), do: error_json(assigns)
  def render("500.json", assigns), do: error_json(assigns)

  defp error_json(%{errors: errors}) do
    %{
      errors: Enum.map(errors, fn(error) ->
        %{
          detail: error.message
        }
      end)
    }
  end

  def template_not_found(_template, assigns) do
    render "500.html", assigns
  end
end
