defmodule DealogBackofficeWeb.OrganizationMessagesLive do
  use DealogBackofficeWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket =
      assign(socket, page_title: gettext("My organization"), active_page: :organization_messages)

    {:ok, socket}
  end
end
