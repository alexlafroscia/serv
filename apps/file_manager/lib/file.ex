defmodule Serv.File do
  @moduledoc """
  Representation of a file

  A file represents a group of file instances, representing the same "logical"
  file. Each instance represents a version of this particular file
  """

  @enforce_keys [:name, :extension]
  defstruct [:name, :extension]

  @directory Application.get_env(:file_manager, :data_path)
  @meta_file_name "meta.json"

  @doc """
  Retrieve a list of instances of a file
  """
  def get_instances(file) do
    location = storage_directory(file)

    case File.ls(location) do
      {:ok, contents} -> contents
        |> Enum.filter(fn(f) -> !String.equivalent?(f, @meta_file_name) end)
        |> Enum.map(fn(hash) -> get(file, hash) end)
        |> Enum.map(fn({:ok, file}) -> file end)
    end
  end

  @doc """
  Gets a file instance by the hash or label

  ## Examples

    iex> file = %Serv.File{name: "fixture-a", extension: "txt"}
    iex> Serv.File.get(file, "abc")
    {:ok, %Serv.FileInstance{
      file: %Serv.File{
        name: "fixture-a",
        extension: "txt"
      },
      hash: "abc"
    }}

    iex> file = %Serv.File{name: "fixture-a", extension: "txt"}
    iex> Serv.File.get(file, "default")
    {:ok, %Serv.FileInstance{
      file: %Serv.File{
        name: "fixture-a",
        extension: "txt"
      },
      hash: "abc"
    }}

    iex> file = %Serv.File{name: "fixture-a", extension: "txt"}
    iex> Serv.File.get(file, "some-unknown-identifier")
    {:error, :not_found}

  """
  def get(file, hash) do
    file_directory = Serv.File.storage_directory(file)
    instance_dir = [file_directory, hash] |> Path.join

    case File.dir?(instance_dir) do
      true ->
        {:ok, %Serv.FileInstance{file: file, hash: hash}}
      false ->
        get_by_label(file, hash)
    end
  end

  @doc """
  Fetch the labels for the file, with the corresponding instances

  ## Examples

    iex> file = %Serv.File{name: "fixture-a", extension: "txt"}
    iex> Serv.File.labels(file)
    %{"default" => %Serv.FileInstance{
      file: %Serv.File{
        name: "fixture-a",
        extension: "txt"
      },
      hash: "abc"}
    }

  """
  def labels(file) do
    case metadata(file) do
      {:ok, meta} ->
        label_map = meta["labels"]
        label_map
          |> Map.keys
          |> Enum.reduce(%{}, fn(key, acc) ->
            hash = label_map[key]
            {:ok, instance} = get(file, hash)
            Map.merge(acc, %{key => instance})
          end)
      {:error, reason} ->
        {:error, reason}
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

  defp metadata(file) do
    storage_path = storage_directory(file)
    meta_file = Path.join([storage_path, @meta_file_name])

    case File.read(meta_file) do
      {:ok, meta_content} ->
        Poison.Parser.parse(meta_content)
      {:error, reason} ->
        {:error, reason}
    end
  end

  defp get_by_label(file, label) do
    labels = labels(file)

    case Map.fetch(labels, label) do
      {:ok, instance} ->
        {:ok, instance}
      :error ->
        {:error, :not_found}
    end
  end
end
