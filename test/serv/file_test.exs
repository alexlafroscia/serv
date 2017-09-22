defmodule ServFileTest do
  use Serv.DataCase

  test "creating a file by file name" do
    {:ok, file} = Serv.File.create("some-file.txt")

    assert file.name == "some-file"
    assert file.extension == "txt"
    assert file.inserted_at
  end

  test "rejecting a file with a space in the name" do
    assert {:error, _} = Serv.File.create("some file.txt")
  end

  @tag with_fixtures: true
  test "retrieving the instances of a file", %{s_file: file} do
    instances = Serv.File.get_instances(file)
    first = Enum.at(instances, 0)

    assert first.hash == "abc"
    assert first.content == "foo"
    assert first.file_id == file.id

    second = Enum.at(instances, 1)
    assert second.hash == "def"
    assert second.content == "bar"
    assert second.file_id == file.id
  end

  @tag with_fixtures: true
  test "it can get a file by hash", %{s_file: file} do
    {:ok, instance} = Serv.File.get(file, "abc")

    assert instance.hash == "abc"
    assert instance.content == "foo"
    assert instance.file_id == file.id
  end

  @tag :skip
  @tag with_fixtures: true
  test "it can get a file by tag", %{s_file: file} do
    {:ok, instance} = Serv.File.get(file, "default")

    assert instance.hash == "abc"
    assert instance.content == "foo"
    assert instance.file_id == file.id
  end

  @tag with_fixtures: true
  test "it rejects an unknown identifier when getting a file instance", %{s_file: file} do
    assert {:error, :not_found} == Serv.File.get(file, "klasdjasf")
  end
end
