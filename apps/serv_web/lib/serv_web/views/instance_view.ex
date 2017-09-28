defmodule ServWeb.InstanceView do
  @moduledoc false
  use ServWeb, :view

  def render("instance.json", %{instance: instance}) do
    %{
      id: instance.id,
      type: "instances",
      attributes: %{
        "hash": instance.hash,
        "created-at": instance.inserted_at
      }
    }
  end

  def render("as-relationship", %{instances: instances}) do
    instance_json = Enum.map(instances, fn(instance) ->
      %{type: "instances", id: instance.id}
    end)

    %{data: instance_json}
  end
end
