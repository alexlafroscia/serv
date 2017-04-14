defmodule Serv.WebServer.AssetController do
  @moduledoc """
  AssetController

  Responsible for serving up static files
  """
  use Serv.WebServer.Web, :controller

  def show(conn, %{"file_name" => file_name}) do
    case Serv.FileManager.get_file(file_name) do
      nil ->
        conn
        |> put_status(:not_found)
        |> text("")
      file ->
        conn
        |> render_content(file)
    end
  end

  defp render_content(conn, file) do
    content = file
              |> Serv.File.get_instances
              |> Enum.at(0)
              |> Serv.FileInstance.get_content

    text(conn, content)
  end
end
