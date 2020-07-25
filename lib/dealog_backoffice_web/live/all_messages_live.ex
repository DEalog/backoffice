defmodule DealogBackofficeWeb.AllMessagesLive do
  use DealogBackofficeWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket = assign(socket, page_title: "Alle Meldungen", active_page: :all_messages)
    {:ok, socket}
  end
end
