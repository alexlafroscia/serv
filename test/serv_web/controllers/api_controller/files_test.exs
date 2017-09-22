defmodule ServWeb.APIControllerFilesTest do
  use ServWeb.ConnCase
  use Serv.DataCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  @fixture_a %{
    "id" => "fixture-a.txt",
    "type" => "file",
    "attributes" => %{
      "name" => "fixture-a",
      "extension" => "txt"
    },
    "relationships" => %{
      "instances" => %{
        "data" => [
          %{"type" => "instance", "id" => "abc"},
          %{"type" => "instance", "id" => "def"}
        ]
      }
    }
  }

  @tag with_fixtures: true
  test "lists all entries on index", %{conn: conn} do
    conn = get conn, api_path(conn, :index)
    data = json_response(conn, 200)["data"]

    assert Enum.member?(data, @fixture_a)
  end

  @tag with_fixtures: true
  test "shows chosen resource", %{conn: conn} do
    conn = get conn, "/api/files/fixture-a.txt"

    assert json_response(conn, 200)["data"] == @fixture_a
  end

  @tag with_fixtures: true
  test "includes instances in response when requested", %{conn: conn} do
    conn = get conn, "/api/files/fixture-a.txt?include=instances"

    assert json_response(conn, 200)["data"] == @fixture_a
    assert json_response(conn, 200)["included"] == [
      %{
        "type" => "instance",
        "id" => "abc"
      },
      %{
        "type" => "instance",
        "id" => "def"
      }
    ]
  end

  @tag with_fixtures: true
  test "renders page not found when id is nonexistent", %{conn: conn} do
    conn = get conn, "/api/files/some-unknown-file.txt"

    assert conn.status == 404
  end
end
