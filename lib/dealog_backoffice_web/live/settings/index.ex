defmodule DealogBackofficeWeb.SettingsLive.Index do
  use DealogBackofficeWeb, :live_view

  alias DealogBackoffice.Accounts

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign_defaults(socket, session)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def apply_action(socket, :index, _params) do
    assign(
      socket,
      page_title: gettext("Settings"),
      active_page: :settings,
      users: Accounts.list()
    )
  end
end
