defmodule ServWeb.Config do
  @moduledoc """
  Configuration options for Serv

  Pulled out into a module for stubbing
  """

  def password do
    Application.get_env(:serv_web, :password, "")
  end
end

