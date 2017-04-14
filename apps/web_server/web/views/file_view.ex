defmodule Serv.WebServer.FileView do
  @moduledoc false
  use Serv.WebServer.Web, :view

  def render("index.json", %{files: files}) do
    %{data: render_many(files, Serv.WebServer.FileView, "file.json")}
  end

  def render("show.json", %{file: file}) do
    %{data: render_one(file, Serv.WebServer.FileView, "file.json")}
  end

  def render("file.json", %{file: file}) do
    instances = file
      |> Serv.File.get_instances

    %{
      id: Serv.File.file_name(file),
      type: "file",
      attributes: %{
        name: file.name,
        extension: file.extension
      },
      relationships: %{
        instances: Serv.WebServer.InstanceView.render("as-relationship", %{instances: instances})
      }
    }
  end
end
