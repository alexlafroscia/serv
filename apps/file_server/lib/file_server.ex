defmodule FileServer do
  @moduledoc false

  import Plug.Conn

  def fetch(%{path_info: path_info} = conn) when length(path_info) != 1 do
    conn
    |> send_resp(:not_found, "")
  end

  def fetch(conn) do
    file_name = Enum.at(conn.path_info, 0)

    instance_id = conn
                  |> fetch_instance_id

    format = conn
             |> Plug.Conn.get_req_header("accept-encoding")
             |> determine_encoding

    conn =
      case format do
        :gzip -> conn
          |> Plug.Conn.put_resp_header("content-encoding", "gzip")
        :original -> conn
      end

    tapper_id = conn
                |> Tapper.Plug.fetch
                |> Tapper.start_span(name: "fetching file content from database")

    conn =
      case Serv.FileManager.get_file_content(file_name, instance_id, format) do
        [f, i, c] ->
          Tapper.finish_span(tapper_id)
          conn
          |> render_content(f, i, c)
        nil ->
          conn
          |> resp(:not_found, "")
      end

    conn
      |> send_resp
  end

  defp render_content(conn, file, instance, %{content: content}) do
    mime = MIME.type(file.extension)
    conn = conn
           |> Plug.Conn.put_resp_content_type(mime)

    match_header = conn
                   |> Plug.Conn.get_req_header("if-none-match")
                   |> Enum.at(0)
                   |> unwrap_quoted_value

    conn = conn
           |> Plug.Conn.put_resp_header("etag", "\"" <> instance.hash <> "\"")

    if instance.hash == match_header do
      conn
      |> Plug.Conn.resp(:not_modified, "")
    else
      conn
      |> resp(:ok, content)
    end
  end

  defp fetch_instance_id(conn) do
    if conn.query_string == "" do
      get_instance_id_from_header(conn)
    else
      String.replace(conn.query_string, "=", "")
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

  defp get_instance_id_from_header(conn) do
    case Plug.Conn.get_req_header(conn, "serv-instance-id") do
      value when length(value) == 1 -> Enum.at(value, 0)
      value when length(value) == 0 -> "default"
    end
  end

  defp unwrap_quoted_value(value) when is_binary(value), do: Regex.replace(~r/\"/, value, "")
  defp unwrap_quoted_value(_), do: ""
end