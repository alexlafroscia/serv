defmodule Serv.DataCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's data layer.

  You may define functions here to be used as helpers in
  your tests.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      alias Serv.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Serv.DataCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Serv.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Serv.Repo, {:shared, self()})
    end

    tags =
      if tags[:with_fixtures] do
        file = %Serv.File{}
               |> Serv.File.changeset(%{name: "fixture-a", extension: "txt"})
               |> Serv.Repo.insert!

        instance = %Serv.FileInstance{}
                   |> Serv.FileInstance.changeset(%{
                     file_id: file.id,
                     hash: "abc",
                     content: "foo"
                   })
                   |> Serv.Repo.insert!

        # Set up the "default" tag for the file
        %Serv.FileTag{}
        |> Serv.FileTag.changeset(%{
          label: "default",
          file_id: file.id,
          instance_id: instance.id
        })
        |> Serv.Repo.insert!

        # Set up a second file instance
        instance_2 = %Serv.FileInstance{}
        |> Serv.FileInstance.changeset(%{
          file_id: file.id,
          hash: "def",
          content: "bar"
        })
        |> Serv.Repo.insert!

        tags
        |> Map.put(:s_file, file)
        |> Map.put(:instance, instance)
        |> Map.put(:instance_2, instance_2)
      else
        tags
      end

    tags
  end

  @doc """
  A helper that transform changeset errors to a map of messages.

      assert {:error, changeset} = Accounts.create_user(%{password: "short"})
      assert "password is too short" in errors_on(changeset).password
      assert %{password: ["password is too short"]} = errors_on(changeset)

  """
  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Enum.reduce(opts, message, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end

  def file_match(first, second) do
    assert first.name == second.name
    assert first.extension == second.extension
  end

  def instance_match(first, second) do
    assert first.hash == second.hash
    assert first.content == second.content
  end
end
