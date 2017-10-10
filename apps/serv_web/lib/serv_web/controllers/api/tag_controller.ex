defmodule ServWeb.APITagController do
  @moduledoc false
  require Logger
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
                |> FileTag.changeset(%{
                  instance_id: instance_id
                })
                |> Repo.update

    case changeset do
      {:ok, tag} ->
        break_cache tag

        conn
        |> send_resp(:ok, "")
      {:error, _} ->
        conn |> put_status(400)
        |> render(Serv.ErrorView, "400.json", %{errors: changeset.errors})
    end
  end

  defp break_cache(tag) do
    file = Repo.get(Serv.File, tag.file_id)
    instance = Repo.get(Serv.FileInstance, tag.instance_id)

    file_name = Serv.File.file_name file

    for fs_name <- Node.list do
      Logger.info "Sending update info to #{fs_name}"

      :ok = GenServer.cast(
        {:file_server_registry, fs_name},
        {:update, file_name, tag.label, instance.hash}
      )
    end
  end
end

