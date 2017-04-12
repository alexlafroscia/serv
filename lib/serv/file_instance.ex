defmodule Serv.FileInstance do
  @enforce_keys [:name, :hash, :extension]
  defstruct [:name, :hash, :extension]

  def new(file, instance_file) do
    [hash, extension] = String.split(instance_file, ".")

    %Serv.FileInstance{
      name: file.name,
      hash: hash,
      extension: extension
    }
  end

  def content(instance) do
    path = location_for(instance)

    case File.read(path) do
      {:ok, content} -> to_string(content)
    end
  end

  defp location_for(instance) do
    file_directory = Application.get_env(:serv, :data_path)
    file_name = Enum.join([instance.hash, instance.extension], ".")

    Path.join(file_directory, instance.name)
    |> Path.join(file_name)
  end
end
