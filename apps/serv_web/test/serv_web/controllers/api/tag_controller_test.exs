defmodule ServWeb.APITagControllerTest do
  @moduledoc false
  use ServWeb.ConnCase
  use Serv.DataCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  @tag with_fixtures: true
  test "it can update the instance for a tag", %{conn: conn, instance_2: instance, tag: tag} do
    conn = conn
           |> patch(api_tag_path(conn, :update_instance, tag.id), %{
                data: %{
                  type: "instances",
                  id: instance.id
                }
              })

    assert conn.status == 200

    updated_tag = Serv.Repo.get(Serv.FileTag, tag.id)
    assert updated_tag.instance_id == instance.id
  end
end
