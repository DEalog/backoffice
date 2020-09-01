defmodule DealogBackofficeWeb.FeedbackHelpers do
  @moduledoc """
  Convenience helpers to work with f.e. flash messages.
  """

  @doc """
  Checks if a flash message is present and if so it has a `save_success` key.
  """
  def has_success_flash?(flash) do
    !Enum.empty?(flash) && Map.has_key?(flash, Atom.to_string(:save_success))
  end

  @doc """
  Checks if a flash message is present and if so it has a `save_error` key.
  """
  def has_error_flash?(flash) do
    !Enum.empty?(flash) && Map.has_key?(flash, Atom.to_string(:save_error))
  end

  def has_not_found_error_flash?(flash) do
    !Enum.empty?(flash) && Map.has_key?(flash, Atom.to_string(:not_found_error))
  end
end
