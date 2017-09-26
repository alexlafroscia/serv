defmodule ServWeb.FileView do
  @moduledoc false
  use ServWeb, :view

  def render("index.json", %{files: files}) do
    %{data: render_many(files, ServWeb.FileView, "file.json")}
  end

  def render("show.json", %{file: file, instances: true}) do
    %{
      data: render_one(file, ServWeb.FileView, "file.json"),
      included: render_many(file.instances, ServWeb.InstanceView, "instance.json")
    }
  end

  def render("show.json", %{file: file}) do
    %{data: render_one(file, ServWeb.FileView, "file.json")}
  end

  def render("file.json", %{file: file}) do
    %{
      id: Serv.File.file_name(file),
      type: "file",
      attributes: %{
        name: file.name,
        extension: file.extension
      },
      relationships: %{
        instances: ServWeb.InstanceView.render("as-relationship", %{instances: file.instances})
      }
    }
  end
end
