defmodule ServWeb.FileControllerCreateTest do
  use Serv.DataCase
  use ServWeb.ConnCase

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
end
