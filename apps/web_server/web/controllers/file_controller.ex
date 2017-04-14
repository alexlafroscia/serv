defmodule Serv.WebServer.FileController do
  @moduledoc """
  FileController

  Controller for fielding API requests and interacting with the
  File manager.
  """
  use Serv.WebServer.Web, :controller

  def index(conn, _params) do
    files = Serv.FileManager.list
    render(conn, "index.json", files: files)
  end

  def show(conn, %{"file_name" => file_name}) do
    case Serv.FileManager.get_file(file_name) do
      nil ->
        conn
        |> put_status(:not_found)
        |> render(Serv.WebServer.ErrorView, "not_found.json", %{})
      file ->
        render(conn, "show.json", file: file)
    end
  end

  def file_content(conn, %{"file_name" => file_name}) do
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
