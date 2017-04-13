defmodule ServFileInstanceTest do
  use ExUnit.Case
  doctest Serv.FileInstance

  setup_all do
    fixture_a = %Serv.FileInstance{
      file: %Serv.File{
        name: "fixture-a",
        extension: "txt"
      },
      hash: "abc"
    }

    {:ok, fixture_a: fixture_a}
  end

  test "getting the contents of a file instance", context do
    content = context[:fixture_a]
    |> Serv.FileInstance.get_content

    assert content === "file content\n"
  end

  test "setting the contents of a file instance", context do
    content = "dummy content"

    # Set the content of the file instance
    :ok = Serv.FileInstance.set_content(context[:fixture_a], content)

    written_content = TestHelpers.read_file("fixture-a.txt/abc.txt")
    assert content === written_content

    # Reset the fixtures
    TestHelpers.reset_fixtures()
  end
end
