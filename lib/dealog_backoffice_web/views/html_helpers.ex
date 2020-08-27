defmodule DealogBackofficeWeb.HtmlHelpers do
  @moduledoc """
  Helpers for general usage in HTML documents.
  """

  @doc """
  Check if a given integer is even.

  Return true if even, false if odd.
  """
  def is_even?(number) when is_integer(number), do: rem(number, 2) == 0
end
