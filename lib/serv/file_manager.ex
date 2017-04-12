defmodule Serv.FileManager do
  @moduledoc """
  File Management Module
  """

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
end
