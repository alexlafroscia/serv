defmodule ServWeb.AuthenticateTest do
  @moduledoc false

  use ExUnit.Case, async: true
  use ServWeb.ConnCase

  import Mock

  test "allows all requests if there's no password set", %{conn: conn} do
    with_mock Serv.Config, [password: fn() -> nil end] do
      conn = conn
             |> Serv.Plug.Authenticate.call

      assert conn.state == :unset
    end
  end

  test "allows all requests if the password is an empty string", %{conn: conn} do
    with_mock Serv.Config, [password: fn() -> "" end] do
      conn = conn
             |> Serv.Plug.Authenticate.call

      assert conn.state == :unset
    end
  end

  test "a password is required but not provided", %{conn: conn} do
    with_mock Serv.Config, [password: fn() -> "some password" end] do
      conn = conn
             |> Serv.Plug.Authenticate.call

      assert conn.state == :sent
      assert conn.status == 401
    end
  end

  test "the wrong password is provided", %{conn: conn} do
    with_mock Serv.Config, [password: fn() -> "some password" end] do
      conn = conn
             |> Plug.Conn.put_req_header("serv-password", "some wrong password")
             |> Serv.Plug.Authenticate.call

      assert conn.state == :sent
      assert conn.status == 403
    end
  end

  test "the right password is provided", %{conn: conn} do
    with_mock Serv.Config, [password: fn() -> "some password" end] do
      conn = conn
             |> Plug.Conn.put_req_header("serv-password", "some password")
             |> Serv.Plug.Authenticate.call

      assert conn.state == :unset
    end
  end
end
