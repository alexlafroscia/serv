defmodule ServWeb.TagView do
  @moduledoc false
  use ServWeb, :view

  def render("tag.json", %{tag: tag}) do
    %{
      id: tag.id,
      type: "tag",
      attributes: %{
        "label": tag.label,
        "created-at": tag.inserted_at,
        "updated-at": tag.updated_at
      }
    }
  end

  def render("as-relationship", %{tags: tags}) do
    tag_json = Enum.map(tags, fn(tag) ->
      %{type: "tag", id: tag.id}
    end)

    %{data: tag_json}
  end
end
