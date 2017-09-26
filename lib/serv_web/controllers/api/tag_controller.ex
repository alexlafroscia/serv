defmodule ServWeb.APITagController do
  @moduledoc false
  use ServWeb, :controller

  alias Serv.FileTag
  alias Serv.Repo

  def update_instance(conn, %{
    "tag_id" => tag_id,
    "data" => %{
      "type" => "instances",
      "id" => instance_id
    }
  }) do
    changeset = FileTag
                |> Repo.get(tag_id)
                |> Repo.preload(:file)
                |> Repo.preload(:instance)
                |> FileTag.changeset(%{
                  instance_id: instance_id
                })
                |> Repo.update

    case changeset do
      {:ok, _} ->
        conn
        |> send_resp(:ok, "")
      {:error, _} ->
        conn
        |> put_status(400)
        |> render(Serv.ErrorView, "400.json", %{errors: changeset.errors})
    end
  end
end

