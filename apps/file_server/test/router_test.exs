defmodule FileServer.RouterTest do
  use Serv.DataCase
  use Plug.Test

  @opts FileServer.Router.init([])

  @tag with_fixtures: true
  test "can return the default content of a file" do
    conn = :get
           |> conn("/fixture-a.txt")
           |> Plug.Conn.put_req_header("accept-encoding", "")
           |> FileServer.Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "foo"
    assert Plug.Conn.get_resp_header(conn, "etag") == ["\"abc\""]

    assert Plug.Conn.get_resp_header(conn, "content-type") == [
      "text/plain; charset=utf-8"
    ]
  end

  @tag with_fixtures: true
  test "can specify instance ID as a query param" do
    conn = :get
           |> conn("/fixture-a.txt?def")
           |> Plug.Conn.put_req_header("accept-encoding", "")
           |> FileServer.Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "bar"
    assert Plug.Conn.get_resp_header(conn, "etag") == ["\"def\""]
  end

  @tag with_fixtures: true
  test "can specify instance ID as an HTTP header" do
    conn = :get
           |> conn("/fixture-a.txt")
           |> Plug.Conn.put_req_header("accept-encoding", "")
           |> Plug.Conn.put_req_header("serv-instance-id", "def")
           |> FileServer.Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "bar"
    assert Plug.Conn.get_resp_header(conn, "etag") == ["\"def\""]
  end

  @tag with_fixtures: true
  test "responds with a \"not modified\" if the file has already been requested" do
    conn = :get
           |> conn("/fixture-a.txt")
           |> Plug.Conn.put_req_header("if-none-match", "\"abc\"")
           |> FileServer.Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 304
    assert conn.resp_body == ""
  end

  @tag :skip
  test "can return a GZIP of a file" do
    conn = :get
           |> conn("/fixture-a.txt")
           |> Plug.Conn.put_req_header("accept-encoding", "gzip")
           |> FileServer.Router.call(@opts)

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
  test "it works for requests without an `accept-encoding` header" do
    conn = :get
           |> conn("/fixture-a.txt")
           |> FileServer.Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "foo"

    assert Plug.Conn.get_resp_header(conn, "content-type") == [
      "text/plain; charset=utf-8"
    ]
  end

  test "sends a 404 for files that do not exist" do
    conn = :get
           |> conn("/some-invalid-file.txt")
           |> FileServer.Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 404
    assert conn.resp_body == ""
  end

  describe "handling invalid request URLs" do
    @tag with_fixtures: true
    test "it handles complex paths" do
      # Create a test connection
      conn = :get
             |> conn("/fixture-a.txt/foobar")
             |> FileServer.Router.call(@opts)

      assert conn.state == :sent
      assert conn.status == 404
    end

    @tag with_fixtures: true
    test "it handles no path" do
      # Create a test connection
      conn = :get
             |> conn("/")
             |> FileServer.Router.call(@opts)

      assert conn.state == :sent
      assert conn.status == 404
    end
  end
end
