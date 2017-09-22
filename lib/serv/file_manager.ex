defmodule Serv.FileManager do
  @moduledoc """
  File Management Module
  """

  alias Serv.Repo
  alias Serv.FileInstance

  @doc """
  Returns a list of available file objects
  """
  def list do
    Repo.all(Serv.File)
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
    {name, ext} = parse_filename(name)

    case Repo.get_by(Serv.File, %{name: name, extension: ext}) do
      file when is_nil(file) ->
        {:error, :not_found}
      file ->
        {:ok, file}
    end
  end

  @doc """
  Create a new file

  Given a file name and content, create a new file instance
  """
  def create_instance(file_name, file_content) when is_binary(file_name) do
    with :ok <- validate_name(file_name),
         {:ok, file} <- get_or_create_file(file_name)
    do
      create_instance(file, file_content)
    end
  end

  def create_instance(file, file_content) do
    {:ok, instance} = FileInstance.create(file, file_content)
    ensure_default_tag file, instance
    {:ok, instance}
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

  defp validate_name(file_name) do
    if String.contains? file_name, " "  do
      {:error, :invalid_file_name}
    else
      :ok
    end
  end

  defp get_or_create_file(file_name) do
    case get_file(file_name) do
      {:ok, found_file} -> {:ok, found_file}
      {:error, :not_found} -> Serv.File.create(file_name)
    end
  end

  defp ensure_default_tag(file, instance) do
    tag = Repo.get_by(Serv.FileTag, %{
      file_id: file.id,
      label: "default"
    })

    unless tag do
      Serv.FileInstance.set_label(instance, "default")
    end
  end
end
