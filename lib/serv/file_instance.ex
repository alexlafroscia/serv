defmodule Serv.FileInstance do
  @moduledoc """
  Representation of a file instance

  A file instance is a particular version of a file, identified by a hash of the
  contents
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Serv.FileInstance
  alias Serv.Repo

  schema "instances" do
    field :content, :string
    field :hash, :string
    belongs_to :file, Serv.File
    has_many :tags, Serv.FileTag,
      foreign_key: :instance_id

    timestamps()
  end

  @doc false
  def changeset(%FileInstance{} = file_instance, attrs) do
    file_instance
    |> cast(attrs, [:content, :hash, :file_id])
    |> validate_required([:content, :hash, :file_id])
  end

  @doc """
  Creates a new file instance
  """
  def create(file, file_content) do
    hash = calculate_hash file_content

    new_instance = changeset %FileInstance{}, %{
      hash: hash,
      content: file_content,
      file_id: file.id
    }

    Repo.insert new_instance
  end

  @doc """
  Get the contents of a file instance

  ## Examples

    iex> file = %Serv.File{name: "fixture-a", extension: "txt"}
    iex> {:ok, instance} = Serv.File.get(file, "abc")
    iex> Serv.FileInstance.get_content(instance)
    "file content\\n"

    iex> file = %Serv.File{name: "fixture-a", extension: "txt"}
    iex> {:ok, instance} = Serv.File.get(file, "abc")
    iex> Serv.FileInstance.get_content(instance, :original)
    "file content\\n"

  """
  def get_content(instance, version \\ :original) do
    case version do
      :original -> instance.content
    end
  end

  @doc """
  Add a label for the current instance
  """
  def set_label(instance, label) do
    %Serv.FileTag{}
    |> Serv.FileTag.changeset(%{
      label: label,
      file_id: instance.file_id,
      instance_id: instance.id
    })
    |> Repo.insert
  end

  defp calculate_hash(content) do
    hash = :crypto.hash(:md5, content)
    Base.encode16(hash)
  end
end
