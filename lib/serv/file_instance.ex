defmodule Serv.FileInstance do
  @moduledoc """
  Representation of a file instance

  A file instance is a particular version of a file, identified by a hash of the
  contents
  """

  @enforce_keys [:name, :hash, :extension]
  defstruct [:name, :hash, :extension]

  def new(file, instance_file) do
    [hash, extension] = String.split(instance_file, ".")

    %Serv.FileInstance{
      name: file.name,
      hash: hash,
      extension: extension
    }
  end

  def content(instance) do
    path = location_for(instance)

    case File.read(path) do
      {:ok, content} -> to_string(content)
    end
  end

  defp location_for(instance) do
    file_directory = Application.get_env(:serv, :data_path)
    file_name = Enum.join([instance.hash, instance.extension], ".")

    file_directory
    |> Path.join(instance.name)
    |> Path.join(file_name)
  end
end
