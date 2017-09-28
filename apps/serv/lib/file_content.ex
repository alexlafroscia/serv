defmodule Serv.FileContent do
  @moduledoc """
  Representation of the contents of a file instance

  Independent from the file instance because it can have multiple
  content encodings, each of which should be stored independently
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Serv.FileContent


  schema "contents" do
    field :type, :string
    field :content, :string
    field :instance_id, :id
    field :file_id, :id

    timestamps()
  end

  @doc false
  def changeset(%FileContent{} = file_content, attrs) do
    file_content
    |> cast(attrs, [:type, :content, :instance_id, :file_id])
    |> validate_required([:type, :content, :instance_id, :file_id])
  end
end
