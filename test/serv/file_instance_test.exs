defmodule ServFileInstanceTest do
  use ExUnit.Case
  doctest Serv.FileInstance

  setup_all do
    fixture_a = %Serv.FileInstance{
      name: "fixture-a",
      hash: "abc",
      extension: "txt"
    }

    {:ok, fixture_a: fixture_a}
  end

  test "retrieving the instances of a file", state do
    instances = %Serv.File{name: "fixture-a"}
                |> Serv.File.instances

    assert instances == [
      state[:fixture_a]
    ]
  end

  test "getting the contents of a file instance", state do
    content = state[:fixture_a]
    |> Serv.FileInstance.get_content

    assert content === "file content\n"
  end

  test "setting the contents of a file instance", state do
    fixture_dir = Application.get_env(:serv, :data_path)
    content = "dummy content"

    # Set the content of the file instance
    :ok = Serv.FileInstance.set_content(state[:fixture_a], content)

    # Read the content of the new file
    {:ok, written_content} = File.read(Path.join(fixture_dir, "fixture-a/abc.txt"))

    assert content === written_content

    # Reset the fixtures
    TestHelpers.reset_fixtures()
  end
end
