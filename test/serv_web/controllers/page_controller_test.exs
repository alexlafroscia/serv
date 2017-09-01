defmodule ServWeb.PageControllerTest do
  use ServWeb.ConnCase

  test "GET /ui", %{conn: conn} do
    conn = get conn, "/ui"
    assert html_response(conn, 200) =~ "preact-router-anchor"
  end

  test "GET /ui/anything", %{conn: conn} do
    conn = get conn, "/ui/anything"
    assert html_response(conn, 200) =~ "preact-router-anchor"
  end

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert_redirected_to(conn, "/ui")
  end

  defp assert_redirected_to(conn, expected_url) do
    actual_uri = conn
    |> Plug.Conn.get_resp_header("location")
    |> List.first
    |> URI.parse

    expected_uri = URI.parse(expected_url)

    assert conn.status == 302
    assert actual_uri.scheme == expected_uri.scheme
    assert actual_uri.host == expected_uri.host
    assert actual_uri.path == expected_uri.path

    if actual_uri.query do
      assert Map.equal?(
        URI.decode_query(actual_uri.query),
        URI.decode_query(expected_uri.query)
      )
    end
  end
end
