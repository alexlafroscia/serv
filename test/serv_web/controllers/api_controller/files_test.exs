defmodule ServWeb.APIControllerFilesTest do
  use ServWeb.ConnCase
  use Serv.DataCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  defp fixture_a(tag_id) do
    %{
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
        },
        "tags" => %{
          "data" => [
            %{"type" => "tag", "id" => tag_id}
          ]
        }
      }
    }
  end

  @tag with_fixtures: true
  test "lists all entries on index", %{conn: conn, tag: tag} do
    conn = get conn, api_path(conn, :index)
    data = json_response(conn, 200)["data"]

    assert Enum.member?(data, fixture_a tag.id)
  end

  @tag with_fixtures: true
  test "shows chosen resource", %{conn: conn, tag: tag} do
    conn = get conn, "/api/files/fixture-a.txt"

    assert json_response(conn, 200)["data"] == fixture_a tag.id
  end

  @tag with_fixtures: true
  test "includes instances in response when requested", %{conn: conn, instance: instance, instance_2: instance_2, tag: tag} do
    conn = get conn, "/api/files/fixture-a.txt?include=instances"

    assert json_response(conn, 200)["data"] == fixture_a tag.id
    assert json_response(conn, 200)["included"] == [
      %{
        "type" => "instance",
        "id" => "abc",
        "attributes" => %{
          "uploaded-at" => instance.inserted_at |> NaiveDateTime.to_iso8601
        }
      },
      %{
        "type" => "instance",
        "id" => "def",
        "attributes" => %{
          "uploaded-at" => instance_2.inserted_at |> NaiveDateTime.to_iso8601
        }
      }
    ]
  end

  @tag with_fixtures: true
  test "includes tags in response when requested", %{conn: conn, tag: tag} do
    conn = get conn, "/api/files/fixture-a.txt?include=tags"

    assert json_response(conn, 200)["data"] == fixture_a tag.id
    assert json_response(conn, 200)["included"] == [
      %{
        "type" => "tag",
        "id" => tag.id,
        "attributes" => %{
          "label" => tag.label,
          "created-at" => tag.inserted_at |> NaiveDateTime.to_iso8601,
          "updated-at" => tag.updated_at |> NaiveDateTime.to_iso8601
        }
      }
    ]
  end

  @tag with_fixtures: true
  test "includes instances and tags in response when requested", %{conn: conn, instance: instance, instance_2: instance_2, tag: tag} do
    conn = get conn, "/api/files/fixture-a.txt?include=instances,tags"

    assert json_response(conn, 200)["data"] == fixture_a tag.id
    assert json_response(conn, 200)["included"] == [
      %{
        "type" => "instance",
        "id" => "abc",
        "attributes" => %{
          "uploaded-at" => instance.inserted_at |> NaiveDateTime.to_iso8601
        }
      },
      %{
        "type" => "instance",
        "id" => "def",
        "attributes" => %{
          "uploaded-at" => instance_2.inserted_at |> NaiveDateTime.to_iso8601
        }
      },
      %{
        "type" => "tag",
        "id" => tag.id,
        "attributes" => %{
          "label" => tag.label,
          "created-at" => tag.inserted_at |> NaiveDateTime.to_iso8601,
          "updated-at" => tag.updated_at |> NaiveDateTime.to_iso8601
        }
      }
    ]
  end

  @tag with_fixtures: true
  test "renders page not found when id is nonexistent", %{conn: conn} do
    conn = get conn, "/api/files/some-unknown-file.txt"

    assert conn.status == 404
  end
end
