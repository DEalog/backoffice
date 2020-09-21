defmodule DealogBackofficeWeb.LiveViewTestHelpers do
  @moduledoc """
  Helper functions for testing with Phoenix LiveView.
  """

  alias Phoenix.LiveView.Utils

  @doc """
  Get the flash from a signed token binary. 

  This is a wrapper for `Phoenix.LiveView.Utils.verify_flash`.

  Returns %{"key" => "value"}
  """
  def get_flash_from_token(endpoint, token) do
    Utils.verify_flash(endpoint, token)
  end
end
