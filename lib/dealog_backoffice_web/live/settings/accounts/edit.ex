defmodule DealogBackofficeWeb.SettingsLive.Accounts.Edit do
  use DealogBackofficeWeb, :live_view

  alias DealogBackoffice.{Accounts, AdministrativeAreas}
  alias DealogBackoffice.Accounts.Projections.Account
  alias DealogBackofficeWeb.SettingsLive.Accounts.FormData

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign_defaults(socket, session)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def apply_action(socket, :new, %{"user_id" => user_id}) do
    assign(
      socket,
      page_title: gettext("Create user account"),
      active_page: :settings,
      administrative_areas: get_areas_options(),
      changeset: Accounts.new_account(user_id) |> build_changeset(),
      account: nil
    )
  end

  def apply_action(socket, :change, %{"account_id" => account_id}) do
    {:ok, account} = Accounts.get_account(account_id)

    assign(
      socket,
      page_title: gettext("Change user account"),
      active_page: :settings,
      administrative_areas: get_areas_options(),
      changeset: build_changeset(account)
    )
  end

  defp build_changeset(%Account{} = account) do
    account
    |> FormData.load_from_account()
    |> FormData.changeset_for_account()
  end

  defp get_areas_options() do
    areas =
      AdministrativeAreas.list()
      |> Enum.map(&{"#{&1.type_label} #{&1.name}", &1.ars})

    [{gettext("Please choose an administrative area"), nil}] ++ areas
  end
end
