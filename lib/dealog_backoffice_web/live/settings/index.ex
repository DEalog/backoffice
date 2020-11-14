defmodule DealogBackofficeWeb.SettingsLive.Index do
  use DealogBackofficeWeb, :live_view

  alias DealogBackoffice.Accounts
  alias DealogBackoffice.Accounts.User
  alias DealogBackoffice.AdministrativeAreas

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

  defp get_latest_change(%User{} = user) do
    if user.account do
      account_updated = user.account.updated_at

      user_updated =
        user.updated_at
        |> DateTime.from_naive!("Etc/UTC")

      if DateTime.diff(user_updated, account_updated) < 0, do: account_updated, else: user_updated
    else
      user.updated_at
    end
  end

  defp get_status(%User{} = user) do
    user_status =
      cond do
        user.confirmed_at -> :confirmed
        true -> :unconfirmed
      end

    if user.account do
      {user_status, :onboarded}
    else
      {user_status, :new}
    end
  end

  defp get_area_name(ars) when not is_nil(ars) do
    %{name: name, type_label: type} = AdministrativeAreas.get_by_ars(ars)
    "#{type} #{name}"
  end

  defp get_area_name(_), do: ""
end
