defmodule ServWeb.FileController do
  @moduledoc """
  FileController

  Responsible for serving up static files and uploading new ones
  """
  use ServWeb, :controller

  plug Serv.Plug.Authenticate when action in [:create]

  def show(conn, %{"file_name" => file_name}) do
    instance_id = conn
                  |> fetch_instance_id

    case Serv.FileManager.get_file(file_name) do
      {:ok, file} ->
        conn
        |> render_content(file, instance_id)
      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> text("")
    end
  end

  def create(conn, %{"file" => file}) do
    name = file.filename
    {:ok, file_content} = File.read file.path

    case Serv.FileManager.create_instance(name, file_content) do
      {:ok, _} ->
        conn
        |> put_status(:created)
        |> text("")
      {:error, _} ->
        conn
        |> put_status(:bad_request)
        |> text("")
    end
  end

  defp render_content(conn, file, instance_id) do
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

    match_header = conn
                   |> Plug.Conn.get_req_header("if-none-match")
                   |> Enum.at(0)
                   |> unwrap_quoted_value
    {:ok, instance} = Serv.File.get(file, instance_id)

    if instance.hash == match_header do
      conn
      |> Plug.Conn.resp(:not_modified, "")
    else
      conn
      |> Plug.Conn.put_resp_header("etag", "\"" <> instance.hash <> "\"")
      |> text(Serv.FileInstance.get_content(instance, format))
    end
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
      # true -> :gzip
      true -> :original
      false -> :original
    end
  end

  defp fetch_instance_id(conn) do
    case URI.parse(current_url(conn)).query do
      value when is_binary(value) ->
        String.replace(value, "=", "")
      _ -> get_instance_id_from_header(conn)
    end
  end

  defp get_instance_id_from_header(conn) do
    case Plug.Conn.get_req_header(conn, "serv-instance-id") do
      value when length(value) == 1 -> Enum.at(value, 0)
      value when length(value) == 0 -> "default"
    end
  end

  defp unwrap_quoted_value(value) when is_binary(value), do: Regex.replace(~r/\"/, value, "")
  defp unwrap_quoted_value(_), do: ""
end
