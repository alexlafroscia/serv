defmodule Serv.Config do
  @moduledoc """
  Configuration options for Serv

  Pulled out into a module for stubbing
  """

  def password do
    Application.get_env(:serv, :password, "")
  end
end

