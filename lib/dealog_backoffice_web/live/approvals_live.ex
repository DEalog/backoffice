defmodule DealogBackofficeWeb.ApprovalsLive do
  use DealogBackofficeWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket = assign(socket, page_title: "Freigaben", active_page: :approvals)
    {:ok, socket}
  end
end
