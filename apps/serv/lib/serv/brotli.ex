defmodule Serv.Brotli do
  @moduledoc """
  Helper module for compressing text with Brotli
  """
  require Logger

  @doc """
  Compresses a string
  """
  def compress(text) do
    brotli = Application.get_env(:serv_web, :brotli_path)

    if brotli do
      # Create tmp file for the file content
      {:ok, path} = Briefly.create
      File.write!(path, text)

      # Execute Brotli on the tmp file
      {content, 0} = System.cmd brotli, ["-c", path]

      {:ok, content}
    else
      Logger.debug "Brotli not installed on this system"

      {:error, :unsupported}
    end
  end
end
