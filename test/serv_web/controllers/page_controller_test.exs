defmodule ServWeb.PageControllerTest do
  use ServWeb.ConnCase

  test "GET /ui", %{conn: conn} do
    conn = get conn, "/ui"
    assert html_response(conn, 200) =~ "Welcome to Phoenix!"
  end
end
