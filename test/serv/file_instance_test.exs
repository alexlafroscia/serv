defmodule ServFileInstanceTest do
  use ExUnit.Case
  doctest Serv.FileInstance

  test "retrieving the instances of a file" do
    instances = %Serv.File{name: "fixture-a"}
                |> Serv.File.instances

    assert instances == [
      %Serv.FileInstance{
        name: "fixture-a",
        hash: "abc",
        extension: "txt"
      }
    ]
  end

  test "getting the contents of a file instance" do
    instance = %Serv.FileInstance{
      name: "fixture-a",
      hash: "abc",
      extension: "txt"
    }

    content = instance
      |> Serv.FileInstance.content

    assert content === "file content\n"
  end
end
