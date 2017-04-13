defmodule ServFileManagerTest do
  use ExUnit.Case
  doctest Serv.FileManager

  test "listing the available files" do
    files = Serv.FileManager.list

    assert files == [
      %Serv.File{name: "fixture-a"}
    ]
  end

  test "creating a new instance of an existing file" do
    file_content = "file content"
    instance = Serv.FileManager.create_instance("fixture-a.txt", file_content)

    assert instance == %Serv.FileInstance{
      name: "fixture-a",
      hash: "D10B4C3FF123B26DC068D43A8BEF2D23",
      extension: "txt"
    }

    written_content = TestHelpers.read_file("fixture-a/D10B4C3FF123B26DC068D43A8BEF2D23.txt")
    assert written_content == file_content

    TestHelpers.reset_fixtures()
  end

  test "creating a new file" do
    file_content = "file content"
    instance = Serv.FileManager.create_instance("some-new-file.txt", file_content)

    assert instance == %Serv.FileInstance{
      name: "some-new-file",
      hash: "D10B4C3FF123B26DC068D43A8BEF2D23",
      extension: "txt"
    }

    written_content = TestHelpers.read_file("some-new-file/D10B4C3FF123B26DC068D43A8BEF2D23.txt")
    assert written_content == file_content

    TestHelpers.reset_fixtures()
  end
end
