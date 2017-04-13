defmodule Serv.FileInstance do
  @moduledoc """
  Representation of a file instance

  A file instance is a particular version of a file, identified by a hash of the
  contents
  """

  @enforce_keys [:file, :hash]
  defstruct [:file, :hash]

  @doc """
  Creates a new file instance
  """
  def create(file, file_content) do
    hash = calculate_hash(file_content)
    instance = %Serv.FileInstance{
      file: file,
      hash: hash
    }

    directory = file
                |> Serv.File.storage_directory
                |> Path.join(hash)

    case File.mkdir_p(directory) do
      :ok -> write_content(instance, file_content)
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Gets a file instance by the hash

  ## Examples

    iex> file = %Serv.File{name: "fixture-a", extension: "txt"}
    iex> Serv.FileInstance.get(file, "abc")
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
  Get the contents of a file instance

  ## Examples

    iex> file = %Serv.File{name: "fixture-a", extension: "txt"}
    iex> instance = Serv.FileInstance.get(file, "abc")
    iex> Serv.FileInstance.get_content(instance)
    "file content\\n"

  """
  def get_content(instance) do
    file_name = Serv.File.file_name(instance.file)
    path = instance
           |> location_for
           |> Path.join(file_name)

    case File.read(path) do
      {:ok, content} -> to_string(content)
    end
  end

  defp location_for(instance) do
    file_store = instance.file |> Serv.File.storage_directory

    file_store
    |> Path.join(instance.hash)
  end

  defp write_content(instance, content) do
    file_name = instance.file |> Serv.File.file_name
    full_path = instance
                |> location_for
                |> Path.join(file_name)

    case File.write(full_path, content) do
      :ok -> instance
      {:error, reason} -> {:error, reason}
    end
  end

  defp calculate_hash(content) do
    hash = :crypto.hash(:md5, content)
    Base.encode16(hash)
  end
end
