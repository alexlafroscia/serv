defmodule ServFileInstanceTest do
  use ExUnit.Case
  use Serv.DataCase

  @tag with_fixtures: true
  test "creating a new instance", %{s_file: file} do
    content = "dummy content"
    {:ok, instance} = Serv.FileInstance.create(file, content)

    assert instance.file_id === file.id
    assert instance.hash === "90C55A38064627DCA337DFA5FC5BE120"

    assert content == Serv.FileInstance.get_content(instance)
  end

  @tag with_fixtures: true
  test "getting the gzipped content of a file", %{s_file: file} do
    content = "dummy content"
    {:ok, instance} = Serv.FileInstance.create(file, content)

    assert Serv.FileInstance.get_content(instance, :gzip) == <<31,
      139, 8, 0, 0, 0, 0, 0, 0, 19, 75, 41, 205, 205, 173, 84, 72,
      206, 207, 43, 73, 205, 43, 1, 0, 94, 172, 81, 4, 13, 0, 0, 0>>
  end

  @tag with_fixtures: true
  test "setting a label for a file instance", %{instance: instance} do
    {:ok, tag} = Serv.FileInstance.set_label(instance, "new-label")

    assert tag.file_id == instance.file_id
    assert tag.instance_id == instance.id
  end
end
