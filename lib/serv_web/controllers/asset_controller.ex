defmodule ServWeb.AssetController do
  @moduledoc """
  AssetController

  Responsible for serving up static files
  """
  use ServWeb, :controller

  def show(conn, %{"file_name" => file_name}) do
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
    format = conn
             |> Plug.Conn.get_req_header("accept-encoding")
             |> determine_encoding

    conn =
      case format do
        :gzip -> conn
          |> Plug.Conn.put_resp_header("content-encoding", "gzip")
        :original -> conn
      end

    mime = MIME.type(file.extension)
    conn = conn
           |> Plug.Conn.put_resp_content_type(mime)

    content = file
              |> Serv.File.get_instances
              |> Enum.at(0) # Replace this with a lookup based on hash
              |> Serv.FileInstance.get_content(format)

    text(conn, content)
  end

  defp determine_encoding(values) do
    values =
      if Enum.empty?(values) do
        values
      else
        values
        |> Enum.at(0)
        |> String.split(",", trim: true)
      end

    case Enum.member?(values, "gzip") do
      true -> :gzip
      false -> :original
    end
  end
end
