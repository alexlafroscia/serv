defmodule Serv.WebServer.Endpoint do
  @moduledoc false
  use Phoenix.Endpoint, otp_app: :web_server

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: "_web_server_key",
    signing_salt: "UkrvCcKf"

  plug Serv.WebServer.Router
end
