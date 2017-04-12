defmodule ServFileManagerTest do
  use ExUnit.Case
  doctest Serv.FileManager

  test "listing the available files" do
    files = Serv.FileManager.list

    assert files == [
      %Serv.File{name: "fixture-a"}
    ]
  end
end
