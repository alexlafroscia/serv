defmodule ServWeb.AssetControllerTest do
  use ServWeb.ConnCase
  use Serv.FixtureHelpers

  test "can return the content of a file", %{conn: conn} do
    conn = conn
           |> Plug.Conn.put_req_header("accept-encoding", "")
           |> get("/fixture-a.txt")

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "file content\n"

    assert Plug.Conn.get_resp_header(conn, "content-type") == [
      "text/plain; charset=utf-8"
    ]
  end

  test "returns the default file when version is not specified", %{conn: conn} do
    conn = get conn, "/fixture-b.min.js"

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "def\n"
    assert Plug.Conn.get_resp_header(conn, "etag") == ["\"def\""]
  end

  test "can specify instance ID as a query param", %{conn: conn} do
    conn = get conn, "/fixture-b.min.js?abc"

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "abc\n"
    assert Plug.Conn.get_resp_header(conn, "etag") == ["\"abc\""]
  end

  test "can specify instance ID as an HTTP header", %{conn: conn} do
    conn = conn
           |> Plug.Conn.put_req_header("serv-instance-id", "abc")
           |> get("/fixture-b.min.js")

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "abc\n"
    assert Plug.Conn.get_resp_header(conn, "etag") == ["\"abc\""]
  end

  test "responds with a \"not modified\" if the file has already been requested", %{conn: conn} do
    conn = conn
           |> Plug.Conn.put_req_header("if-none-match", "\"def\"")
           |> get("/fixture-b.min.js")

    assert conn.state == :sent
    assert conn.status == 304
    assert conn.resp_body == ""
  end

  test "can return a GZIP of a file", %{conn: conn} do
    conn = conn
           |> Plug.Conn.put_req_header("accept-encoding", "gzip")
           |> get("/fixture-a.txt")

    assert conn.state == :sent
    assert conn.status == 200
    assert is_binary(conn.resp_body)

    assert Plug.Conn.get_resp_header(conn, "content-type") == [
      "text/plain; charset=utf-8"
    ]

    encoding = conn
               |> Plug.Conn.get_resp_header("content-encoding")
    assert encoding == ["gzip"]
  end

  test "it works for requests without an `accept-encoding` header", %{conn: conn} do
    conn = get conn, "/fixture-a.txt"

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "file content\n"

    assert Plug.Conn.get_resp_header(conn, "content-type") == [
      "text/plain; charset=utf-8"
    ]
  end

  test "sends a 404 for files that do not exist", %{conn: conn} do
    conn = get conn, "/some-invalid-file.txt"

    assert conn.state == :sent
    assert conn.status == 404
    assert conn.resp_body == ""
  end

  test "can upload a new file", %{conn: conn} do
    file_name = "upload-file.txt"
    upload = %Plug.Upload{
      path: Path.join(Serv.FixtureHelpers.upload_fixture_dir(), file_name),
      filename: file_name
    }
    conn = conn
           |> post("/upload", %{"file" => upload})

    assert conn.state == :sent
    assert conn.status == 201
    assert conn.resp_body == ""

    conn = conn
           |> get("/" <> file_name)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "foo\n"
  end
end
