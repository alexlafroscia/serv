defmodule ServFileManagerTest do
  use Serv.DataCase

  import Mock

  @tag with_fixtures: true
  test "creating a new instance of an existing file, with a file name" do
    file_content = "file content"
    {:ok, instance} = Serv.FileManager.create_instance("fixture-a.txt", file_content)

    instance_match(instance, %Serv.FileInstance{
      hash: "D10B4C3FF123B26DC068D43A8BEF2D23"
    })
  end

  @tag with_fixtures: true
  test "creating a new instance of an existing file, with a file struct", %{s_file: file} do
    file_content = "file content"
    {:ok, instance} = Serv.FileManager.create_instance(file, file_content)

    instance_match(instance, %Serv.FileInstance{
      hash: "D10B4C3FF123B26DC068D43A8BEF2D23"
    })
  end

  @tag with_fixtures: true
  test "handling an error during creation", %{s_file: file} do
    with_mock Serv.Repo, [:passthrough], [insert!: fn(_) -> raise Postgrex.Error, message: "foo" end] do
      assert {:error, "foo"} == Serv.FileManager.create_instance(file, "some content")
    end
  end

  @tag with_fixtures: true
  test "creating a new file" do
    file_content = "file content"
    {:ok, instance} = Serv.FileManager.create_instance(
      "some-new-file.txt",
      file_content
    )

    instance_match(instance, %Serv.FileInstance{
      hash: "D10B4C3FF123B26DC068D43A8BEF2D23"
    })

    assert instance.file_id
  end
end
