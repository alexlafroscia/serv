defmodule Mix.Tasks.FileServer do
  use Mix.Task

  @shortdoc "Start the Serv file server"

  @moduledoc false

  @doc false
  def run(args) do
    Mix.Tasks.Run.run ["--no-halt"]
  end
end
