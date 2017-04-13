defmodule ServFileTest do
  use ExUnit.Case
  doctest Serv.File

  test "requires a file name to be provided" do
    %Serv.File{name: nil}
  end

  test "retrieving the instances of a file" do
    instances = %Serv.File{name: "fixture-a"}
                |> Serv.File.get_instances

    assert instances == [
      %Serv.FileInstance{
        name: "fixture-a",
        hash: "abc",
        extension: "txt"
      }
    ]
  end
end
