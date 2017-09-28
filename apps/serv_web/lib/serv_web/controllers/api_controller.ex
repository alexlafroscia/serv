defmodule ServWeb.APIController do
  @moduledoc """
  APIController

  Controller for fielding API requests and interacting with the
  File manager.
  """
  use ServWeb, :controller
  import Ecto.Query, only: [preload: 2]

  alias Serv.Repo

  def check_authenticated(conn, _params) do
    conn
    |> send_resp(:ok, "")
  end

  def index(conn, _params) do
    files = Serv.File
            |> preload(:instances)
            |> preload(:tags)
            |> Repo.all
    render(conn, ServWeb.FileView, "index.json", files: files)
  end

  def show(conn, params) do
    included_relationships = params
                             |> Map.get("include", "")
                             |> String.split(",")
    file_id = params |> Map.get("file_id")

    file = Serv.File
           |> Repo.get(file_id)
           |> Repo.preload(:instances)
           |> Repo.preload(:tags)

    if file do
      render(conn, ServWeb.FileView, "show.json", %{
        file: file,
        instances: Enum.member?(included_relationships, "instances"),
        tags: Enum.member?(included_relationships, "tags")
      })
    else
      conn
      |> put_status(:not_found)
      |> render(ServWeb.ErrorView, "404.json", %{errors: [
           %{
             message: "Not found"
           }
         ]})
    end
  end
end
