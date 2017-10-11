defmodule ServWeb.FileControllerCreateTest do
  use Serv.DataCase
  use ServWeb.ConnCase

  import Mock

  test "can upload a new file without authentication", %{conn: conn} do
    file_name = "upload-file.txt"
    upload = %Plug.Upload{
      path: Path.join(ServWeb.FixtureHelpers.fixture_dir, file_name),
      filename: file_name
    }
    conn = conn
           |> post("/upload", %{"file" => upload})

    assert conn.state == :sent
    assert conn.status == 201
    assert conn.resp_body == ""
  end

  test "returns an error when there's an issue inserting the file", %{conn: conn} do
    with_mock Serv.FileInstance, [:passthrough], [create: fn(_, _) -> {:error, "foo"} end] do
      file_name = "upload-file.txt"
      upload = %Plug.Upload{
        path: Path.join(ServWeb.FixtureHelpers.fixture_dir, file_name),
        filename: file_name
      }
      conn = conn
             |> post("/upload", %{"file" => upload})

      assert conn.state == :sent
      assert conn.status == 400
      assert conn.resp_body == "foo"
    end
  end
end
