require Logger

defmodule Serv.FileInstance do
  @moduledoc """
  Representation of a file instance

  A file instance is a particular version of a file, identified by a hash of the
  contents
  """

  @enforce_keys [:file, :hash]
  defstruct [:file, :hash]

  @doc """
  Generate a new file instance

  ## Examples

    iex> file = %Serv.File{name: "fixture-a", extension: "txt"}
    iex> Serv.FileInstance.new(file, "abc.txt")
    %Serv.FileInstance{
      file: %Serv.File{
        name: "fixture-a",
        extension: "txt"
      },
      hash: "abc"
    }

  """
  def new(file, instance_file) do
    [hash, _] = String.split(instance_file, ".")

    %Serv.FileInstance{
      file: file,
      hash: hash,
    }
  end

  @doc """
  Get the contents of a file instance
  """
  def get_content(instance) do
    path = location_for(instance)

    case File.read(path) do
      {:ok, content} -> to_string(content)
    end
  end

  def set_content(instance, content) do
    path = location_for(instance)
    directory = Path.dirname(path)

    case File.mkdir_p(directory) do
      :ok -> File.write(path, content)
      {:error, reason} -> {:error, reason}
    end

    File.write(path, content)
  end

  defp location_for(instance) do
    file_name = Enum.join([instance.hash, instance.file.extension], ".")
    file_store = instance.file |> Serv.File.storage_directory

    Path.join(file_store, file_name)
  end
end
