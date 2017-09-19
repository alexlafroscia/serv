defmodule Serv.Plug.Authenticate do
  @moduledoc """
  Ensure that the user is authenticated

  Compares the `Serv-Password` header to the configured value
  to ensure that the user is authenticated.

  If no password is configured, then all requests are allowed
  without the header
  """

  def init(_opts), do: false

  def call(conn), do: call(conn, false)
  def call(conn, _opts) do
    case Serv.Config.password do
      password when is_nil(password) ->
        conn
      password when is_binary(password) ->
        if password == "" do
          conn
        else
          conn
          |> validate_password(password)
        end
    end
  end

  defp validate_password(conn, password) do
    provided = conn
               |> Plug.Conn.get_req_header("serv-password")
               |> Enum.at(0)

    cond do
      provided == password ->
        conn
      provided == nil ->
        conn
        |> Plug.Conn.send_resp(401, "")
        |> Plug.Conn.halt
      true ->
        conn
        |> Plug.Conn.send_resp(403, "")
        |> Plug.Conn.halt
    end
  end
end
