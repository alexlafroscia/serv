defmodule ServWeb.APIControllerCheckAuthenticatedTest do
  use ServWeb.ConnCase

  import Mock

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "responds if the user is not authenticated", %{conn: conn} do
    with_mock Serv.Config, [password: fn() -> "password" end] do
      conn = conn
             |> get(api_path(conn, :check_authenticated))

      assert conn.state == :sent
      assert conn.status == 401
    end
  end

  test "responds if the user has the wrong password", %{conn: conn} do
    with_mock Serv.Config, [password: fn() -> "password" end] do
      conn = conn
             |> put_req_header("serv-password", "wrong")
             |> get(api_path(conn, :check_authenticated))

      assert conn.state == :sent
      assert conn.status == 403
    end
  end

  test "responds if the user has the right password", %{conn: conn} do
    with_mock Serv.Config, [password: fn() -> "password" end] do
      conn = conn
             |> put_req_header("serv-password", "password")
             |> get(api_path(conn, :check_authenticated))

      assert conn.state == :sent
      assert conn.status == 200
    end
  end
end
