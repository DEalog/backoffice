defmodule DealogBackofficeWeb.SettingsLive do
  use DealogBackofficeWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket = assign(socket, page_title: gettext("Settings"), active_page: :settings)
    {:ok, socket}
  end
end
