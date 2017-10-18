defmodule Serv.Brotli do
  @moduledoc """
  Helper module for compressing text with Brotli
  """

  @doc "Compresses a string"
  def compress(text) do
    # Create tmp file for the file content
    {:ok, path} = Briefly.create
    File.write!(path, text)

    # Execute Brotli on the tmp file
    brotli = System.find_executable "brotli"
    {content, 0} = System.cmd brotli, ["-c", path]

    content
  end
end
