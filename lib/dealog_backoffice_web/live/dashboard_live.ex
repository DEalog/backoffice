defmodule DealogBackofficeWeb.DashboardLive do
  use DealogBackofficeWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    socket =
      socket
      |> assign_defaults(session)
      |> assign(page_title: gettext("Dashboard"), active_page: :dashboard)

    {:ok, socket}
  end
end
