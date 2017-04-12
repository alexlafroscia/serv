ExUnit.start()

defmodule TestHelpers do
  def reset_fixtures() do
    data_directory = Application.get_env(:serv, :data_path)
    fixture_directory = Path.join(System.cwd(), "test/__fixtures__")
    File.cp_r!(fixture_directory, data_directory)
  end
end

TestHelpers.reset_fixtures()
