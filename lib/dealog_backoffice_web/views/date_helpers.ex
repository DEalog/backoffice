defmodule DealogBackofficeWeb.DateHelpers do
  @moduledoc """
  Helpers for displaying dates.
  """

  def display_date_time(%DateTime{} = date_time) do
    DateTime.shift_zone!(date_time, read_config(:timezone), Tzdata.TimeZoneDatabase)
    |> format_date_time()
  end

  def display_date_time_relative(%DateTime{} = date_time) do
    Timex.lformat!(date_time, "{relative}", read_config(:locale), :relative)
  end

  defp format_date_time(%DateTime{} = date_time) do
    Timex.format!(date_time, read_config(:date_time_format))
  end

  defp read_config(key) do
    Application.get_env(:dealog_backoffice, :i18n)[key]
  end
end
