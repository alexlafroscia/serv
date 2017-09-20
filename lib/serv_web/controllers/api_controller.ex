defmodule ServWeb.APIController do
  @moduledoc """
  APIController

  Controller for fielding API requests and interacting with the
  File manager.
  """
  use ServWeb, :controller

  def check_authenticated(conn, _params) do
    conn
    |> send_resp(:ok, "")
  end

  def index(conn, _params) do
    files = Serv.FileManager.list
    render(conn, ServWeb.FileView, "index.json", files: files)
  end

  def show(conn, params) do
    file_name = Map.get(params, "file_name")
    include = Map.get(params, "include", "")
    included_relationships = String.split(include, ",")

    case Serv.FileManager.get_file(file_name) do
      {:ok, file} ->
        if include_instances(included_relationships) do
          instances = Serv.File.get_instances file
          render(conn, ServWeb.FileView, "show.json", file: file, instances: instances)
        else
          render(conn, ServWeb.FileView, "show.json", file: file)
        end
      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> render(ServWeb.ErrorView, "404.json", %{})
    end
  end

  defp include_instances(relationships) do
    Enum.find(relationships, fn(rel) -> rel == "instances" end)
  end
end
