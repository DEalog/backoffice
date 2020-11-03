defmodule DealogBackofficeWeb.SettingsLive.Onboarding do
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

  def apply_action(socket, :new, %{"id" => user_id}) do
    assign(
      socket,
      page_title: gettext("Onboard user"),
      active_page: :settings,
      account: %{id: nil, first_name: nil, last_name: nil, user_id: user_id},
      user: Accounts.get_user!(user_id)
    )
  end
end
