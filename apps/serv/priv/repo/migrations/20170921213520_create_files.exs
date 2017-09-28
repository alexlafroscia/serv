defmodule Serv.Repo.Migrations.CreateFiles do
  use Ecto.Migration

  def change do
    create table(:files) do
      add :name, :string
      add :extension, :string

      timestamps()
    end

  end
end
