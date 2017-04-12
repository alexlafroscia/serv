require Logger

defmodule Serv.File do
  @moduledoc """
  Representation of a file

  A file represents a group of file instances, representing the same "logical"
  file. Each instance represents a version of this particular file
  """

  alias Serv.FileInstance, as: FileInstance

  @enforce_keys [:name]
  defstruct name: nil

  @doc """
  Retrieve a list of instances of a file
  """
  def instances(file) do
    location = location_for(file)

    case File.ls(location) do
      {:ok, instances} -> instances
        |> Enum.map(fn(instance) -> FileInstance.new(file, instance) end)
    end
  end

  defp location_for(file) do
    file_directory = Application.get_env(:serv, :data_path)

    Path.join(file_directory, file.name)
  end
end
