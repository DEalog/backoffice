defmodule DealogBackofficeWeb.MediaHelpers do
  @moduledoc """
  Helpers for common media related functions.
  """

  @doc """
  Hash a value to get f.e. an avatar.
  """
  def get_hash(value) do
    :crypto.hash(:md5, value) |> Base.encode16(case: :lower)
  end
end
