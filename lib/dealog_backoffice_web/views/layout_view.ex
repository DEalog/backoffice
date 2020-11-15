defmodule DealogBackofficeWeb.LayoutView do
  use DealogBackofficeWeb, :view

  def get_hostname do
    System.get_env("HOSTNAME")
  end
end
