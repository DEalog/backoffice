defmodule DealogBackofficeWeb.DashboardLive do
  use DealogBackofficeWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket = assign(socket, page_title: gettext("Dashboard"), active_page: :dashboard)
    {:ok, socket}
  end
end
