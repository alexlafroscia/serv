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
      {:ok, file} ->
        render(conn, "show.json", file: file)
      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> render(Serv.WebServer.ErrorView, "404.json", %{})
    end
  end

  def file_content(conn, %{"file_name" => file_name}) do
    case Serv.FileManager.get_file(file_name) do
      {:ok, file} ->
        conn
        |> render_content(file)
      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> text("")
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