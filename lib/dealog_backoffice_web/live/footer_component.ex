defmodule DealogBackofficeWeb.FooterComponent do
  use Phoenix.LiveComponent

  @impl true
  def mount(socket) do
    socket =  assign(socket, current_year: display_year(), version: display_version())
    {:ok, socket}
  end

  defp display_year do
    today =  DateTime.utc_now()
    today.year
  end

  defp display_version do
    {:ok, vsn} = :application.get_key(:dealog_backoffice, :vsn)
    List.to_string(vsn)
  end
end
