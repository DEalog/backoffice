defmodule DealogBackofficeWeb.NewMessageLive do
  use DealogBackofficeWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket = assign(socket, title: gettext("New message"), active_page: :new_message)
    {:ok, socket}
  end
end
