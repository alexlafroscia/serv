defmodule Serv.FileInstance do
  @moduledoc """
  Representation of a file instance

  A file instance is a particular version of a file, identified by a hash of the
  contents
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Serv.FileContent
  alias Serv.FileInstance
  alias Serv.Repo

  schema "instances" do
    field :hash, :string
    belongs_to :file, Serv.File
    has_many :tags, Serv.FileTag,
      foreign_key: :instance_id

    timestamps()
  end

  @doc false
  def changeset(%FileInstance{} = file_instance, attrs) do
    file_instance
    |> cast(attrs, [:hash, :file_id])
    |> validate_required([:hash, :file_id])
  end

  @doc """
  Creates a new file instance
  """
  def create(file, file_content) do
    hash = calculate_hash file_content

    new_instance = changeset %FileInstance{}, %{
      hash: hash,
      file_id: file.id
    }

    try do
      Repo.transaction fn ->
        # Create the file instance
        instance = Repo.insert!(new_instance)

        # Insert the file content
        %FileContent{}
        |> FileContent.changeset(%{
          type: "original",
          instance_id: instance.id,
          file_id: file.id,
          content: file_content
        })
        |> Repo.insert!

        %FileContent{}
        |> FileContent.changeset(%{
          type: "gzip",
          instance_id: instance.id,
          file_id: file.id,
          content: :zlib.gzip(file_content)
        })
        |> Repo.insert!

        with {:ok, compressed_content} <- Serv.Brotli.compress(file_content) do
          %FileContent{}
          |> FileContent.changeset(%{
            type: "brotli",
            instance_id: instance.id,
            file_id: file.id,
            content: compressed_content
          })
          |> Repo.insert!
        end

        instance
      end
    rescue
      e in Postgrex.Error ->
        message = Exception.message e
        {:error, message}
    end
  end

  @doc """
  Get the contents of a file instance
  """
  def get_content(instance), do: get_content(instance, :original)

  def get_content(instance, type) when is_atom(type) do
    get_content instance, Atom.to_string(type)
  end

  def get_content(instance, type) do
    file_content = Repo.get_by(FileContent, %{
      type: type,
      file_id: instance.file_id,
      instance_id: instance.id
    })

    if is_nil(file_content) do
      nil
    else
      file_content.content
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
