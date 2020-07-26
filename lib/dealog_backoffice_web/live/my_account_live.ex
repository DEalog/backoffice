defmodule DealogBackofficeWeb.MyAccountLive do
  use DealogBackofficeWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket = assign(socket, page_title: gettext("My account"), active_page: :my_account)
    {:ok, socket}
  end
end
