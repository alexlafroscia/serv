defmodule Serv.File do
  @moduledoc """
  Representation of a file

  A file represents a group of file instances, representing the same "logical"
  file. Each instance represents a version of this particular file
  """

  @enforce_keys [:name, :extension]
  defstruct [:name, :extension]

  @directory Application.get_env(:file_manager, :data_path)

  @doc """
  Retrieve a list of instances of a file
  """
  def get_instances(file) do
    location = storage_directory(file)

    case File.ls(location) do
      {:ok, instances} -> instances
        |> Enum.map(fn(hash) -> get(file, hash) end)
    end
  end

  @doc """
  Gets a file instance by the hash

  ## Examples

    iex> file = %Serv.File{name: "fixture-a", extension: "txt"}
    iex> Serv.File.get(file, "abc")
    %Serv.FileInstance{
      file: %Serv.File{
        name: "fixture-a",
        extension: "txt"
      },
      hash: "abc"
    }

  """
  def get(file, hash) do
    file_directory = Serv.File.storage_directory(file)
    instance_dir = [file_directory, hash] |> Path.join

    case File.dir?(instance_dir) do
      true -> %Serv.FileInstance{file: file, hash: hash}
      false -> nil
    end
  end

  @doc """
  Get the full name for a file

  ## Examples

    iex> file = %Serv.File{name: "fixture-a", extension: "txt"}
    iex> file |> Serv.File.file_name
    "fixture-a.txt"

  """
  def file_name(file) do
    [file.name, file.extension] |> Enum.join(".")
  end

  @doc """
  Get the storage directory for a file
  """
  def storage_directory(file) do
    file_directory = file_name(file)
    Path.join(@directory, file_directory)
  end
end
