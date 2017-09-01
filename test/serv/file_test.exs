defmodule ServFileTest do
  use ExUnit.Case
  use Serv.FixtureHelpers
  doctest Serv.File

  test "retrieving the instances of a file" do
    file = %Serv.File{
      name: "fixture-a",
      extension: "txt"
    }

    assert Serv.File.get_instances(file) == [
      %Serv.FileInstance{
        file: file,
        hash: "abc"
      }
    ]
  end

  test "getting the storage for a file" do
    file = %Serv.File{
      name: "fixture-a",
      extension: "txt"
    }

    directory = Serv.File.storage_directory file
    correct_path = Path.join(FixtureHelpers.temp_dir, "fixture-a.txt")

    assert directory === correct_path
    assert File.dir?(directory)
  end
end
