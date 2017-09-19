defmodule ServWeb.FileControllerCreateTest do
  use ServWeb.ConnCase
  use Serv.FixtureHelpers

  test "can upload a new file without authentication", %{conn: conn} do
    file_name = "upload-file.txt"
    upload = %Plug.Upload{
      path: Path.join(Serv.FixtureHelpers.upload_fixture_dir(), file_name),
      filename: file_name
    }
    conn = conn
           |> post("/upload", %{"file" => upload})

    assert conn.state == :sent
    assert conn.status == 201
    assert conn.resp_body == ""

    conn = conn
           |> get("/" <> file_name)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "foo\n"
  end
end
