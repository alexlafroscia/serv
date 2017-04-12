require Logger

defmodule Serv.FileManager do
  @moduledoc """
  File Management Module
  """

  @doc """
  Returns a list of available file objects
  """
  def list do
    file_directory = Application.get_env(:serv, :data_path)

    case File.ls(file_directory) do
      {:ok, files} -> files
        |> Enum.map(fn(name) -> %Serv.File{name: name} end)
    end
  end
end
