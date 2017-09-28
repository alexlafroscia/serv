defmodule ServFileContentTest do
  use Serv.DataCase

  test "it validates required fields" do
    changeset = %Serv.FileContent{}
                |> Serv.FileContent.changeset(%{})

    assert "can't be blank" in errors_on(changeset).type
    assert "can't be blank" in errors_on(changeset).content
    assert "can't be blank" in errors_on(changeset).instance_id
    assert "can't be blank" in errors_on(changeset).file_id
  end
end
