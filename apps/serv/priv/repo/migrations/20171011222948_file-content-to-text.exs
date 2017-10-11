defmodule :"Elixir.Serv.Repo.Migrations.File-content-to-text" do
  use Ecto.Migration

  def change do
    alter table(:contents) do
      modify :content, :text
    end
  end
end
