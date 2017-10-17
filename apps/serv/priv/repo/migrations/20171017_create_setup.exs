defmodule Serv.Repo.Migrations.CreateFiles do
  use Ecto.Migration

  def change do
    create table(:files) do
      add :name, :string
      add :extension, :string

      timestamps()
    end

    create table(:instances) do
      add :hash, :string
      add :file_id, references(:files)

      timestamps()
    end

    create table(:tags) do
      add :label, :string
      add :file_id, references(:files)
      add :instance_id, references(:instances)

      timestamps()
    end

    create table(:contents) do
      add :type, :string
      add :content, :binary
      add :instance_id, references(:instances, on_delete: :nothing)
      add :file_id, references(:files, on_delete: :nothing)

      timestamps()
    end

    create index(:contents, [:file_id])
    create index(:contents, [:instance_id])
    create index(:contents, [:type])

  end
end
