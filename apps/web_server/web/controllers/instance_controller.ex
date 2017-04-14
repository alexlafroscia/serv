defmodule Serv.WebServer.InstanceController do
  use Serv.WebServer.Web, :controller

  # def index(conn, _params) do
  #   instances = Repo.all(Instance)
  #   render(conn, "index.json", instances: instances)
  # end

  # def create(conn, %{"instance" => instance_params}) do
  #   changeset = Instance.changeset(%Instance{}, instance_params)

  #   case Repo.insert(changeset) do
  #     {:ok, instance} ->
  #       conn
  #       |> put_status(:created)
  #       |> put_resp_header("location", instance_path(conn, :show, instance))
  #       |> render("show.json", instance: instance)
  #     {:error, changeset} ->
  #       conn
  #       |> put_status(:unprocessable_entity)
  #       |> render(Serv.WebServer.ChangesetView, "error.json", changeset: changeset)
  #   end
  # end

  # def show(conn, %{"id" => id}) do
  #   instance = Repo.get!(Instance, id)
  #   render(conn, "show.json", instance: instance)
  # end
end
