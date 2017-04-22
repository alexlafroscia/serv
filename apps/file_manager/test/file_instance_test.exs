defmodule ServFileInstanceTest do
  use ExUnit.Case
  use Serv.FixtureHelpers
  doctest Serv.FileInstance

  @fixture_a %Serv.File{
    name: "fixture-a",
    extension: "txt"
  }

  @tag :reset_fixtures
  test "creating a new instance" do
    file = @fixture_a
    content = "dummy content"
    {:ok, instance} = Serv.FileInstance.create(file, content)

    assert instance.file === file
    assert instance.hash === "90C55A38064627DCA337DFA5FC5BE120"

    written_content = FixtureHelpers.read_file(
      "fixture-a.txt/90C55A38064627DCA337DFA5FC5BE120/fixture-a.txt"
    )
    assert written_content === content

    gzip_written_content = FixtureHelpers.read_file(
      "fixture-a.txt/90C55A38064627DCA337DFA5FC5BE120/fixture-a.txt.gz"
    )
    assert is_binary(gzip_written_content)
  end

  test "getting the gzipped content of a file" do
    instance = %Serv.FileInstance{
      file: @fixture_a,
      hash: "abc"
    }
    content = Serv.FileInstance.get_content(instance, :gzip)

    assert is_binary(content)
  end
end
