defmodule Serv.FileManager do
  @moduledoc """
  File Management Module
  """

  alias Serv.FileInstance

  @directory Application.get_env(:serv, :data_path)

  @doc """
  Returns a list of available file objects
  """
  def list do
    case File.ls(@directory) do
      {:ok, files} -> files
        |> Enum.map(fn(name) ->
          {name, ext} = parse_filename(name)
          %Serv.File{name: name, extension: ext}
        end)
    end
  end

  @doc """
  Get a File by name

  ## Examples

    iex> Serv.FileManager.get_file("fixture-a.txt")
    {:ok, %Serv.File{name: "fixture-a", extension: "txt"}}

    iex> Serv.FileManager.get_file("some-invalid-file")
    {:error, :not_found}

  """
  def get_file(name) do
    full_path = Path.join(@directory, name)

    case File.dir?(full_path) do
      true ->
        {name, ext} = parse_filename(name)
        {:ok, %Serv.File{name: name, extension: ext}}
      false ->
        {:error, :not_found}
    end
  end

  @doc """
  Create a new file

  Given a file name and content, create a new file instance
  """
  def create_instance(file_name, file_content) when is_binary(file_name) do
    file =
      case get_file(file_name) do
        {:ok, found_file} -> found_file
        {:error, :not_found} ->
          Serv.File.create(file_name)
      end

    create_instance(file, file_content)
  end

  def create_instance(file, file_content) do
    case FileInstance.create(file, file_content) do
      {:ok, instance} ->
        ensure_default_label(instance)
      {:error, errors} ->
        {:error, errors}
    end
  end

  @doc """
  Pull apart the name and extension for a string

    iex> Serv.FileManager.parse_filename("some-file.txt")
    {"some-file", "txt"}

  """
  def parse_filename(path) do
    ext = Path.extname(path)
    basename = Path.basename(path, ext)

    {basename, String.slice(ext, 1..-1)}
  end

  defp ensure_default_label(instance) do
    case Serv.File.get(instance.file, "default") do
      {:ok, _} ->
        {:ok, instance}
      {:error, :not_found} ->
        :ok = Serv.FileInstance.set_label(instance, "default")
        {:ok, instance}
    end
  end
end
