defmodule ServWeb.TagView do
  @moduledoc false
  use ServWeb, :view

  def render("tag.json", %{tag: tag}) do
    %{
      id: tag.id,
      type: "tags",
      attributes: %{
        "label": tag.label,
        "created-at": tag.inserted_at,
        "updated-at": tag.updated_at
      },
      relationships: %{
        file: %{
          data: %{
            type: "files", id: tag.file_id
          }
        },
        instance: %{
          data: %{
            type: "instances", id: tag.instance_id
          }
        }
      }
    }
  end

  def render("as-relationship", %{tags: tags}) do
    tag_json = Enum.map(tags, fn(tag) ->
      %{type: "tags", id: tag.id}
    end)

    %{data: tag_json}
  end
end
