ExUnit.start()

defmodule TestHelpers do
  def reset_fixtures() do
    tmp = temp_dir()
    fixture_directory = Path.join(System.cwd(), "test/__fixtures__")

    File.rm_rf(tmp)
    File.cp_r!(fixture_directory, tmp)
  end

  def read_file(path) do
    full_path = Path.join(temp_dir(), path)
    File.read!(full_path)
  end

  defp temp_dir() do
    Application.get_env(:serv, :data_path)
  end
end

TestHelpers.reset_fixtures()
