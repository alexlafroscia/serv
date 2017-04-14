defmodule Serv.WebServer.ErrorView do
  @moduledoc false
  use Serv.WebServer.Web, :view

  def render("not_found.json", %{}) do
    %{
      errors: [

      ]
    }
  end
end
