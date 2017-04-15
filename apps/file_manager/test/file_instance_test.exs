defmodule ServFileInstanceTest do
  use ExUnit.Case
  doctest Serv.FileInstance

  setup do
    on_exit(fn() ->
      # Reset the fixtures
      TestHelpers.reset_fixtures()
    end)
  end

  test "creating a new instance" do
    file = %Serv.File{
      name: "fixture-a",
      extension: "txt"
    }
    content = "dummy content"
    {:ok, instance} = Serv.FileInstance.create(file, content)

    assert instance.file === file
    assert instance.hash === "90C55A38064627DCA337DFA5FC5BE120"

    written_content = TestHelpers.read_file(
      "fixture-a.txt/90C55A38064627DCA337DFA5FC5BE120/fixture-a.txt"
    )
    assert written_content === content
  end
end
