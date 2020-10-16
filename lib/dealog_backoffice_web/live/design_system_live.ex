defmodule DealogBackofficeWeb.DesignSystemLive do
  use DealogBackofficeWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    socket =
      socket
      |> assign_defaults(session)
      |> assign(page_title: gettext("Design System"), active_page: :design_system)

    {:ok, socket}
  end
end
