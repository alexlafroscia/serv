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
        |> Enum.map(fn(name) -> %Serv.File{name: name} end)
    end
  end

  @doc """
  Get a File by name

  ## Examples

    iex> Serv.FileManager.get_file("fixture-a")
    %Serv.File{name: "fixture-a"}

    iex> Serv.FileManager.get_file("some-invalid-file")
    nil

  """
  def get_file(name) do
    full_path = Path.join(@directory, name)

    case File.dir?(full_path) do
      true -> %Serv.File{name: name}
      false -> nil
    end
  end

  @doc """
  Create a new file

  Given a file name and content, create a new file instance
  """
  def create_instance(file_name, file_content) do
    ext = Path.extname(file_name)

    file =
      case get_file(file_name) do
        nil ->
          base = Path.basename(file_name, ext)
          %Serv.File{name: base}
        file -> file
      end

    hash = calculate_hash(file_content)
    instance_name = Enum.join([hash, ext], "")

    instance = FileInstance.new(file, instance_name)

    case FileInstance.set_content(instance, file_content) do
      :ok -> instance
      {:error, error} -> error
    end
  end

  defp calculate_hash(content) do
    hash = :crypto.hash(:md5, content)
    Base.encode16(hash)
  end
end
