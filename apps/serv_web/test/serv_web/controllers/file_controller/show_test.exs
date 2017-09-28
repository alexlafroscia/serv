defmodule ServWeb.FileControllerShowTest do
  use Serv.DataCase
  use ServWeb.ConnCase

  @tag with_fixtures: true
  test "can return the content of a file", %{conn: conn} do
    conn = conn
           |> Plug.Conn.put_req_header("accept-encoding", "")
           |> get("/fixture-a.txt")

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "foo"

    assert Plug.Conn.get_resp_header(conn, "content-type") == [
      "text/plain; charset=utf-8"
    ]
  end

  @tag with_fixtures: true
  test "returns the default file when version is not specified", %{conn: conn} do
    conn = get conn, "/fixture-a.txt"

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "foo"
    assert Plug.Conn.get_resp_header(conn, "etag") == ["\"abc\""]
  end

  @tag with_fixtures: true
  test "can specify instance ID as a query param", %{conn: conn} do
    conn = get conn, "/fixture-a.txt?def"

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "bar"
    assert Plug.Conn.get_resp_header(conn, "etag") == ["\"def\""]
  end

  @tag with_fixtures: true
  test "can specify instance ID as an HTTP header", %{conn: conn} do
    conn = conn
           |> Plug.Conn.put_req_header("serv-instance-id", "def")
           |> get("/fixture-a.txt")

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "bar"
    assert Plug.Conn.get_resp_header(conn, "etag") == ["\"def\""]
  end

  @tag with_fixtures: true
  test "responds with a \"not modified\" if the file has already been requested", %{conn: conn} do
    conn = conn
           |> Plug.Conn.put_req_header("if-none-match", "\"abc\"")
           |> get("/fixture-a.txt")

    assert conn.state == :sent
    assert conn.status == 304
    assert conn.resp_body == ""
  end

  @tag :skip
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

  @tag with_fixtures: true
  test "it works for requests without an `accept-encoding` header", %{conn: conn} do
    conn = get conn, "/fixture-a.txt"

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "foo"

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
end
