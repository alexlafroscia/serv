defmodule ServWeb.FileController do
  @moduledoc """
  FileController

  Controller for fielding API requests and interacting with the
  File manager.
  """
  use ServWeb, :controller

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
        |> render(ServWeb.ErrorView, "404.json", %{})
    end
  end
end
