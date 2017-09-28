defmodule ServWeb.APIControllerFilesTest do
  use ServWeb.ConnCase
  use Serv.DataCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  @tag with_fixtures: true
  test "lists all entries on index", %{conn: conn, s_file: file, instance: instance, instance_2: instance_2, tag: tag} do
    conn = get conn, api_path(conn, :index)
    data = json_response(conn, 200)["data"]

    assert Enum.member?(data, %{
      "id" => file.id,
      "type" => "files",
      "attributes" => %{
        "name" => "fixture-a",
        "extension" => "txt"
      },
      "relationships" => %{
        "instances" => %{
          "data" => [
            %{"type" => "instances", "id" => instance.id},
            %{"type" => "instances", "id" => instance_2.id}
          ]
        },
        "tags" => %{
          "data" => [
            %{"type" => "tags", "id" => tag.id}
          ]
        }
      }
    })
  end

  @tag with_fixtures: true
  test "shows chosen resource", %{conn: conn, s_file: file, instance: instance, instance_2: instance_2, tag: tag} do
    conn = get conn, "/api/files/#{file.id}"

    assert json_response(conn, 200)["data"] == %{
      "id" => file.id,
      "type" => "files",
      "attributes" => %{
        "name" => "fixture-a",
        "extension" => "txt"
      },
      "relationships" => %{
        "instances" => %{
          "data" => [
            %{"type" => "instances", "id" => instance.id},
            %{"type" => "instances", "id" => instance_2.id}
          ]
        },
        "tags" => %{
          "data" => [
            %{"type" => "tags", "id" => tag.id}
          ]
        }
      }
    }
  end

  @tag with_fixtures: true
  test "includes instances in response when requested", %{conn: conn, s_file: file, instance: instance, instance_2: instance_2, tag: tag} do
    conn = get conn, "/api/files/#{file.id}?include=instances"

    assert json_response(conn, 200)["data"] == %{
      "id" => file.id,
      "type" => "files",
      "attributes" => %{
        "name" => "fixture-a",
        "extension" => "txt"
      },
      "relationships" => %{
        "instances" => %{
          "data" => [
            %{"type" => "instances", "id" => instance.id},
            %{"type" => "instances", "id" => instance_2.id}
          ]
        },
        "tags" => %{
          "data" => [
            %{"type" => "tags", "id" => tag.id}
          ]
        }
      }
    }
    assert json_response(conn, 200)["included"] == [
      %{
        "type" => "instances",
        "id" => instance.id,
        "attributes" => %{
          "hash" => instance.hash,
          "created-at" => instance.inserted_at |> NaiveDateTime.to_iso8601
        }
      },
      %{
        "type" => "instances",
        "id" => instance_2.id,
        "attributes" => %{
          "hash" => instance_2.hash,
          "created-at" => instance_2.inserted_at |> NaiveDateTime.to_iso8601
        }
      }
    ]
  end

  @tag with_fixtures: true
  test "includes tags in response when requested", %{conn: conn, s_file: file, instance: instance, instance_2: instance_2, tag: tag} do
    conn = get conn, "/api/files/#{file.id}?include=tags"

    assert json_response(conn, 200)["data"] == %{
      "id" => file.id,
      "type" => "files",
      "attributes" => %{
        "name" => "fixture-a",
        "extension" => "txt"
      },
      "relationships" => %{
        "instances" => %{
          "data" => [
            %{"type" => "instances", "id" => instance.id},
            %{"type" => "instances", "id" => instance_2.id}
          ]
        },
        "tags" => %{
          "data" => [
            %{"type" => "tags", "id" => tag.id}
          ]
        }
      }
    }
    assert json_response(conn, 200)["included"] == [
      %{
        "type" => "tags",
        "id" => tag.id,
        "attributes" => %{
          "label" => tag.label,
          "created-at" => tag.inserted_at |> NaiveDateTime.to_iso8601,
          "updated-at" => tag.updated_at |> NaiveDateTime.to_iso8601
        },
        "relationships" => %{
          "file" => %{
            "data" => %{
              "type" => "files", "id" => tag.file_id,
            }
          },
          "instance" => %{
            "data" => %{
              "type" => "instances", "id" => tag.instance_id
            }
          }
        }
      }
    ]
  end

  @tag with_fixtures: true
  test "includes instances and tags in response when requested", %{conn: conn, s_file: file, instance: instance, instance_2: instance_2, tag: tag} do
    conn = get conn, "/api/files/#{file.id}?include=instances,tags"

    assert json_response(conn, 200)["data"] == %{
      "id" => file.id,
      "type" => "files",
      "attributes" => %{
        "name" => "fixture-a",
        "extension" => "txt"
      },
      "relationships" => %{
        "instances" => %{
          "data" => [
            %{"type" => "instances", "id" => instance.id},
            %{"type" => "instances", "id" => instance_2.id}
          ]
        },
        "tags" => %{
          "data" => [
            %{"type" => "tags", "id" => tag.id}
          ]
        }
      }
    }
    assert json_response(conn, 200)["included"] == [
      %{
        "type" => "instances",
        "id" => instance.id,
        "attributes" => %{
          "hash" => instance.hash,
          "created-at" => instance.inserted_at |> NaiveDateTime.to_iso8601
        }
      },
      %{
        "type" => "instances",
        "id" => instance_2.id,
        "attributes" => %{
          "hash" => instance_2.hash,
          "created-at" => instance_2.inserted_at |> NaiveDateTime.to_iso8601
        }
      },
      %{
        "type" => "tags",
        "id" => tag.id,
        "attributes" => %{
          "label" => tag.label,
          "created-at" => tag.inserted_at |> NaiveDateTime.to_iso8601,
          "updated-at" => tag.updated_at |> NaiveDateTime.to_iso8601
        },
        "relationships" => %{
          "file" => %{
            "data" => %{
              "type" => "files", "id" => tag.file_id,
            }
          },
          "instance" => %{
            "data" => %{
              "type" => "instances", "id" => tag.instance_id
            }
          }
        }
      }
    ]
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    conn = get conn, "/api/files/1"

    assert conn.status == 404
  end
end
