defmodule ServFileTest do
  use ExUnit.Case
  doctest Serv.File

  test "requires a file name to be provided" do
    %Serv.File{name: nil}
  end
end
