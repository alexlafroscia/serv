defmodule Serv.WebServer.InstanceView do
  @moduledoc false
  use Serv.WebServer.Web, :view

  def render("as-relationship", %{instances: instances}) do
    instance_json = Enum.map(instances, fn(instance) ->
      %{ type: "instance", id: instance.hash }
    end)

    %{ data: instance_json }
  end
end
