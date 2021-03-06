defmodule Serv.FileManager do
  @moduledoc """
  File Management Module
  """
  import Ecto.Query, only: [from: 2, where: 3]

  alias Serv.Repo
  alias Serv.FileContent
  alias Serv.FileInstance
  alias Serv.FileTag

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

  def get_file_query(file_name) when is_binary(file_name) do
    {name, ext} = parse_filename(file_name)

    Serv.File
    |> where([file], file.name == ^name and file.extension == ^ext)
  end

  @doc """
  Get a File, FileInstance and FileContent based on the file name, identifier and
  encoding

  Essentially, this method turns the params given in an request for a file and
  turns them into the data required for the response
  """
  def get_file_content(file_name, identifier, content_encoding) do
    encoding = Atom.to_string(content_encoding)
    file_query = file_name
                 |> get_file_query

    tag_content = file_query
                  |> get_file_content_by_tag(identifier, encoding)
                  |> Repo.one

    if tag_content do
      tag_content
    else
      instance_content = file_query
                         |> get_file_content_by_hash(identifier, encoding)
                         |> Repo.one

      if instance_content do
        instance_content
      else
        nil
      end
    end
  end

  defp get_file_content_by_tag(file_query, label, encoding) do
    from f in file_query,
      join: t in FileTag,
        where: t.label == ^label,
        join: i in FileInstance,
          where: t.instance_id == i.id and i.file_id == f.id,
          join: c in FileContent,
            where: c.instance_id == i.id and c.file_id == f.id and c.type == ^encoding,
      select: [f, i, c]
  end

  defp get_file_content_by_hash(file_query, hash, encoding) do
    from f in file_query,
      join: i in FileInstance,
        where: i.hash == ^hash and i.file_id == f.id,
        join: c in FileContent,
          where: c.instance_id == i.id and c.file_id == f.id and c.type == ^encoding,
      select: [f, i, c]
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
    with {:ok, instance} <- FileInstance.create(file, file_content) do
      ensure_default_tag file, instance
      {:ok, instance}
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
