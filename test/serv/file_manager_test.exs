defmodule ServFileManagerTest do
  use Serv.DataCase

  @tag with_fixtures: true
  test "listing the available files", %{s_file: file} do
    files = Serv.FileManager.list

    assert Enum.at(files, 0) == file
  end

  @tag with_fixtures: true
  test "creating a new instance of an existing file, with a file name" do
    file_content = "file content"
    {:ok, instance} = Serv.FileManager.create_instance("fixture-a.txt", file_content)

    instance_match(instance, %Serv.FileInstance{
      hash: "D10B4C3FF123B26DC068D43A8BEF2D23",
      content: file_content
    })
  end

  @tag with_fixtures: true
  test "creating a new instance of an existing file, with a file struct", %{s_file: file} do
    file_content = "file content"
    {:ok, instance} = Serv.FileManager.create_instance(file, file_content)

    instance_match(instance, %Serv.FileInstance{
      hash: "D10B4C3FF123B26DC068D43A8BEF2D23",
      content: file_content
    })
  end

  @tag with_fixtures: true
  test "creating a new file" do
    file_content = "file content"
    {:ok, instance} = Serv.FileManager.create_instance(
      "some-new-file.txt",
      file_content
    )

    instance_match(instance, %Serv.FileInstance{
      hash: "D10B4C3FF123B26DC068D43A8BEF2D23",
      content: file_content
    })

    assert instance.file_id
  end
end
