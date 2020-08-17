defmodule DealogBackofficeWeb.DateHelpers do
  @moduledoc """
  Helpers for displaying dates.
  """

  # TODO Make config
  @timezone "Europe/Berlin"
  @locale "de"
  @date_time_format "{0D}.{0M}.{YYYY} {h24}:{m}:{s}"

  def display_date_time(%NaiveDateTime{} = date_time) do
    DateTime.from_naive!(date_time, @timezone, Tzdata.TimeZoneDatabase)
    |> format_date_time()
  end

  def display_date_time(%DateTime{} = date_time) do
    DateTime.shift_zone!(date_time, @timezone, Tzdata.TimeZoneDatabase)
    |> format_date_time()
  end

  def display_date_time_relative(%DateTime{} = date_time) do
    Timex.lformat!(date_time, "{relative}", @locale, :relative)
  end

  defp format_date_time(%DateTime{} = date_time) do
    Timex.format!(date_time, @date_time_format)
  end
end
