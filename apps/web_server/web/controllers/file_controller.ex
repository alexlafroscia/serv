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

  # def create(conn, %{"file" => file_params}) do
  #   changeset = File.changeset(%File{}, file_params)

  #   case Repo.insert(changeset) do
  #     {:ok, file} ->
  #       conn
  #       |> put_status(:created)
  #       |> put_resp_header("location", file_path(conn, :show, file))
  #       |> render("show.json", file: file)
  #     {:error, changeset} ->
  #       conn
  #       |> put_status(:unprocessable_entity)
  #       |> render(Serv.WebServer.ChangesetView, "error.json", changeset: changeset)
  #   end
  # end
end
