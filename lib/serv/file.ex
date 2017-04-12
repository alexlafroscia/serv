require Logger

defmodule Serv.File do
  @enforce_keys [:name]
  defstruct name: nil

  @doc """
  Retrieve a list of instances of a file
  """
  def instances(file) do
    location = location_for(file)

    case File.ls(location) do
      {:ok, instances} -> instances
        |> Enum.map(fn(instance) -> Serv.FileInstance.new(file, instance) end)
    end
  end

  defp location_for(file) do
    file_directory = Application.get_env(:serv, :data_path)

    Path.join(file_directory, file.name)
  end
end
