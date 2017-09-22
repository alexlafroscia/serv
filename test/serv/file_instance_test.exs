defmodule ServFileInstanceTest do
  use ExUnit.Case
  use Serv.DataCase

  @tag with_fixtures: true
  test "creating a new instance", %{s_file: file} do
    content = "dummy content"
    {:ok, instance} = Serv.FileInstance.create(file, content)

    assert instance.file_id === file.id
    assert instance.hash === "90C55A38064627DCA337DFA5FC5BE120"
  end

  @tag :skip
  test "getting the gzipped content of a file"

  @tag with_fixtures: true
  test "setting a label for a file instance", %{instance: instance} do
    {:ok, tag} = Serv.FileInstance.set_label(instance, "new-label")

    assert tag.file_id == instance.file_id
    assert tag.instance_id == instance.id
  end
end
