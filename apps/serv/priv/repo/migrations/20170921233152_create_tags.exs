defmodule Serv.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :label, :string
      add :file_id, references(:files)
      add :instance_id, references(:instances)

      timestamps()
    end

  end
end
