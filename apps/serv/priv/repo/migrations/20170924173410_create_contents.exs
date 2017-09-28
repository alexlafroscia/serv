defmodule Serv.Repo.Migrations.CreateContents do
  use Ecto.Migration

  def change do
    create table(:contents) do
      add :type, :string
      add :content, :string
      add :instance_id, references(:instances, on_delete: :nothing)
      add :file_id, references(:files, on_delete: :nothing)

      timestamps()
    end

    create index(:contents, [:instance_id])
    create index(:contents, [:file_id])

    alter table(:instances) do
      remove :content
    end
  end
end
