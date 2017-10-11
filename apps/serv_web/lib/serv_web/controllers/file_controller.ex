defmodule ServWeb.FileController do
  @moduledoc """
  FileController

  Responsible for serving up static files and uploading new ones
  """
  use ServWeb, :controller

  def create(conn, %{"file" => file}) do
    name = file.filename
    {:ok, file_content} = File.read file.path

    case Serv.FileManager.create_instance(name, file_content) do
      {:ok, _} ->
        conn
        |> put_status(:created)
        |> text("")
      {:error, message} ->
        conn
        |> put_status(:bad_request)
        |> text(message)
    end
  end
end
