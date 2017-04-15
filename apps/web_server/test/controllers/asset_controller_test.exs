defmodule Serv.WebServer.AssetControllerTest do
  use Serv.WebServer.ConnCase

  test "can return the content of a file", %{conn: conn} do
    conn = get conn, "/fixture-a.txt"

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "file content\n"
  end

  test "sends a 404 for files that do not exist", %{conn: conn} do
    conn = get conn, "/some-invalid-file.txt"

    assert conn.state == :sent
    assert conn.status == 404
    assert conn.resp_body == ""
  end
end
