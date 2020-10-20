defmodule DealogBackofficeWeb.SettingsLive do
  use DealogBackofficeWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    socket =
      socket
      |> assign_defaults(session)
      |> assign(page_title: gettext("Settings"), active_page: :settings)

    {:ok, socket}
  end
end
