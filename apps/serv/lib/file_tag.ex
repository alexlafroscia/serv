defmodule Serv.FileTag do
  @moduledoc """
  A tag that identifies a file instance by name
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Serv.FileTag

  schema "tags" do
    field :label, :string
    belongs_to :file, Serv.File
    belongs_to :instance, Serv.FileInstance

    timestamps()
  end

  @doc false
  def changeset(%FileTag{} = file_tag, attrs) do
    file_tag
    |> cast(attrs, [:label, :file_id, :instance_id])
    |> validate_required([:label, :file_id, :instance_id])
  end
end
