defmodule Serv.File do
  @moduledoc """
  Representation of a file

  A file represents a group of file instances, representing the same "logical"
  file. Each instance represents a version of this particular file
  """

  alias Serv.FileInstance, as: FileInstance

  @enforce_keys [:name, :extension]
  defstruct [:name, :extension]

  @directory Application.get_env(:serv, :data_path)

  @doc """
  Retrieve a list of instances of a file
  """
  def get_instances(file) do
    location = storage_directory(file)

    case File.ls(location) do
      {:ok, instances} -> instances
        |> Enum.map(fn(instance) -> FileInstance.new(file, instance) end)
    end
  end

  @doc """
  Get the storage directory for a file
  """
  def storage_directory(file) do
    file_directory = [file.name, file.extension] |> Enum.join(".")
    Path.join(@directory, file_directory)
  end
end
