defmodule Serv.FixtureHelpers do
  @moduledoc """
  Helper functionality for dealing with fixtures
  """

  @doc false
  defmacro __using__(_opts) do
    quote do
      alias Serv.FixtureHelpers

      # Reset the fixtures to start, to ensure that we start in the right state
      setup_all do
        FixtureHelpers.reset()

        :ok
      end

      # Clean up after any test with the `:reset_fixtures` tag
      setup context do
        if context[:reset_fixtures] do
          on_exit fn ->
            FixtureHelpers.reset()
          end
        end

        :ok
      end
    end
  end

  def reset do
    tmp = temp_dir()
    fixture_directory = Path.join(__DIR__, "../__fixtures__")

    File.rm_rf(tmp)
    File.cp_r!(fixture_directory, tmp)
  end

  def read_file(path) do
    full_path = Path.join(temp_dir(), path)
    File.read!(full_path)
  end

  def temp_dir do
    Application.get_env(:serv, :data_path)
  end
end
