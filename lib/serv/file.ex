defmodule Serv.File do
  @moduledoc """
  Representation of a file

  A file represents a group of file instances, representing the same "logical"
  file. Each instance represents a version of this particular file
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Serv.Repo

  schema "files" do
    field :extension, :string
    field :name, :string
    has_many :instances, Serv.FileInstance
    has_many :tags, Serv.FileTag

    timestamps()
  end

  @doc """
  Create a new file, setting up the initial metadata
  """
  def create(file_name) do
    {name, ext} = Serv.FileManager.parse_filename(file_name)

    %Serv.File{}
    |> Serv.File.changeset(%{name: name, extension: ext})
    |> Serv.Repo.insert
  end

  @doc false
  def changeset(%Serv.File{} = file, attrs) do
    file
    |> cast(attrs, [:name, :extension])
    |> validate_required([:name, :extension])
    |> validate_length(:name, min: 1)
    |> validate_format(:name, ~r/^((?!\s).)*$/) # Ensure no whitespace in name
  end

  @doc """
  Retrieve a list of instances of a file
  """
  def get_instances(file) do
    file = Repo.preload(file, :instances)
    file.instances
  end

  @doc """
  Gets a file instance by the hash or label
  """
  def get(file, hash) do
    instance = Repo.get_by(Serv.FileInstance, %{
      file_id: file.id,
      hash: hash
    })

    if instance do
      {:ok, instance}
    else
      get_by_label(file, hash)
    end
  end

  @doc """
  Get the full name for a file

  ## Examples

    iex> file = %Serv.File{name: "fixture-a", extension: "txt"}
    iex> file |> Serv.File.file_name
    "fixture-a.txt"

  """
  def file_name(file) do
    [file.name, file.extension] |> Enum.join(".")
  end

  defp get_by_label(file, label) do
    tag = Serv.FileTag
          |> Repo.get_by(%{file_id: file.id, label: label})
          |> Repo.preload(:instance)

    if tag do
      {:ok, tag.instance}
    else
      {:error, :not_found}
    end
  end
end
