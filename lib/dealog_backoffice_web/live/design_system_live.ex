defmodule DealogBackofficeWeb.DesignSystemLive do
  use DealogBackofficeWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket = assign(socket, page_title: gettext("Design System"), active_page: :design_system)
    {:ok, socket}
  end
end
