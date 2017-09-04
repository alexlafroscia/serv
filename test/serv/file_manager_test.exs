defmodule ServFileManagerTest do
  use ExUnit.Case
  use Serv.FixtureHelpers
  doctest Serv.FileManager

  test "listing the available files" do
    files = Serv.FileManager.list

    assert Enum.member?(files, %Serv.File{name: "fixture-a", extension: "txt"})
    assert Enum.member?(files, %Serv.File{name: "fixture-b.min", extension: "js"})
  end

  @tag :reset_fixtues
  test "creating a new instance of an existing file, with a file name" do
    file_content = "file content"
    {:ok, instance} = Serv.FileManager.create_instance("fixture-a.txt", file_content)

    assert instance == %Serv.FileInstance{
      file: %Serv.File{
        name: "fixture-a",
        extension: "txt"
      },
      hash: "D10B4C3FF123B26DC068D43A8BEF2D23"
    }

    written_content = FixtureHelpers.read_file(
      "fixture-a.txt/D10B4C3FF123B26DC068D43A8BEF2D23/fixture-a.txt"
    )
    assert written_content == file_content
  end

  @tag :reset_fixtues
  test "creating a new instance of an existing file, with a file struct" do
    file_content = "file content"
    file = %Serv.File{
      name: "fixture-a",
      extension: "txt"
    }
    {:ok, instance} = Serv.FileManager.create_instance(file, file_content)

    assert instance == %Serv.FileInstance{
      file: file,
      hash: "D10B4C3FF123B26DC068D43A8BEF2D23"
    }

    written_content = FixtureHelpers.read_file(
      "fixture-a.txt/D10B4C3FF123B26DC068D43A8BEF2D23/fixture-a.txt"
    )
    assert written_content == file_content
  end

  @tag :reset_fixtues
  test "creating a new file" do
    file_content = "file content"
    {:ok, instance} = Serv.FileManager.create_instance(
      "some-new-file.txt",
      file_content
    )

    assert instance == %Serv.FileInstance{
      file: %Serv.File{
        name: "some-new-file",
        extension: "txt"
      },
      hash: "D10B4C3FF123B26DC068D43A8BEF2D23"
    }

    written_content = FixtureHelpers.read_file(
      "some-new-file.txt/D10B4C3FF123B26DC068D43A8BEF2D23/some-new-file.txt"
    )
    assert written_content == file_content

    {:ok, meta} = "some-new-file.txt/meta.json"
                  |> FixtureHelpers.read_file
                  |> Poison.Parser.parse

    assert meta ==  %{
      "labels" => %{
        "default" => "D10B4C3FF123B26DC068D43A8BEF2D23"
      }
    }
  end

  test "rejects a file with a space in the name" do
    assert {:error, :invalid_file_name} == Serv.FileManager.create_instance(
      "some name with spaces.txt",
      "some content"
    )
  end
end
