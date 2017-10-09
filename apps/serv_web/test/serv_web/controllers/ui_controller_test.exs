defmodule ServWeb.UIControllerTest do
  use ServWeb.ConnCase

  test "sends the UI when getting the index", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "preact-router-anchor"
  end

  test "sends the UI when getting some arbitrary URL", %{conn: conn} do
    conn = get conn, "/anything"
    assert html_response(conn, 200) =~ "preact-router-anchor"
  end
end
