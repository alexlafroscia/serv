require Logger

defmodule Serv.FileManager do
  @moduledoc """
  File Management Module
  """

  alias Serv.FileInstance

  @directory Application.get_env(:file_manager, :data_path)

  @doc """
  Returns a list of available file objects
  """
  def list do
    case File.ls(@directory) do
      {:ok, files} -> files
        |> Enum.map(fn(name) ->
          [name, ext] = parse_filename(name)
          %Serv.File{name: name, extension: ext}
        end)
    end
  end

  @doc """
  Get a File by name

  ## Examples

    iex> Serv.FileManager.get_file("fixture-a.txt")
    %Serv.File{
      name: "fixture-a",
      extension: "txt"
    }

    iex> Serv.FileManager.get_file("some-invalid-file")
    nil

  """
  def get_file(name) do
    full_path = Path.join(@directory, name)

    case File.dir?(full_path) do
      true ->
        [name, ext] = parse_filename(name)
        %Serv.File{name: name, extension: ext}
      false -> nil
    end
  end

  @doc """
  Create a new file

  Given a file name and content, create a new file instance
  """
  def create_instance(file_name, file_content) when is_binary(file_name) do
    [name, ext] = parse_filename(file_name)

    file =
      case get_file(file_name) do
        nil ->
          %Serv.File{name: name, extension: ext}
        found_file -> found_file
      end

    create_instance(file, file_content)
  end

  def create_instance(file, file_content) do
    FileInstance.create(file, file_content)
  end

  defp parse_filename(path) do
    String.split(path, ".")
  end
end
