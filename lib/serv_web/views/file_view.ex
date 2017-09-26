defmodule ServWeb.FileView do
  @moduledoc false
  use ServWeb, :view

  def render("index.json", %{files: files}) do
    %{data: render_many(files, ServWeb.FileView, "file.json")}
  end

  def render("show.json", %{file: file, instances: instances, tags: tags}) do
    included =
      if instances do
        render_many(file.instances, ServWeb.InstanceView, "instance.json")
      else
        []
      end

    included =
      if tags do
        included
        |> Enum.concat(render_many(file.tags, ServWeb.TagView, "tag.json"))
      else
        included
      end

    %{
      data: render_one(file, ServWeb.FileView, "file.json"),
      included: included
    }
  end

  def render("file.json", %{file: file}) do
    %{
      id: file.id,
      type: "files",
      attributes: %{
        name: file.name,
        extension: file.extension
      },
      relationships: %{
        instances: ServWeb.InstanceView.render("as-relationship", %{instances: file.instances}),
        tags: ServWeb.TagView.render("as-relationship", %{tags: file.tags})
      }
    }
  end
end
