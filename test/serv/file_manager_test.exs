defmodule ServFileManagerTest do
  use ExUnit.Case
  doctest Serv

  test "listing the available files" do
    files = Serv.FileManager.list

    assert files == [
      %Serv.File{name: "nl-global-header"}
    ]
  end
end
