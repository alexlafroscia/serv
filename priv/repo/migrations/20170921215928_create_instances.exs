defmodule Serv.Repo.Migrations.CreateInstances do
  use Ecto.Migration

  def change do
    create table(:instances) do
      add :content, :string
      add :hash, :string
      add :file_id, references(:files)

      timestamps()
    end

  end
end
