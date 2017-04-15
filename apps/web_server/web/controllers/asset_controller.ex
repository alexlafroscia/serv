defmodule Serv.WebServer.AssetController do
  @moduledoc """
  AssetController

  Responsible for serving up static files
  """
  use Serv.WebServer.Web, :controller

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

    content = file
              |> Serv.File.get_instances
              |> Enum.at(0) # Replace this with a lookup based on hash
              |> Serv.FileInstance.get_content(format)

    text(conn, content)
  end

  defp determine_encoding(values) do
    values = values
             |> Enum.at(0)
             |> String.split(",", trim: true)

    case Enum.member?(values, "gzip") do
      true -> :gzip
      false -> :original
    end
  end
end
