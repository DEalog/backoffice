defmodule DealogBackofficeWeb.SettingsLive.Accounts.Edit do
  use DealogBackofficeWeb, :live_view

  alias DealogBackoffice.{Accounts, AdministrativeAreas}

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
      account: %{
        id: nil,
        first_name: nil,
        last_name: nil,
        user_id: user_id,
        administrative_area: nil,
        organization: nil,
        position: nil
      },
      user: Accounts.get_user!(user_id)
    )
  end

  def apply_action(socket, :change, %{"account_id" => account_id}) do
    {:ok, account} = Accounts.get_account(account_id)

    assign(
      socket,
      page_title: gettext("Change user account"),
      active_page: :settings,
      administrative_areas: get_areas_options(),
      account: account,
      user: account.user
    )
  end

  defp get_areas_options() do
    areas =
      AdministrativeAreas.list()
      |> Enum.map(&{"#{&1.type_label} #{&1.name}", &1.ars})

    [{gettext("Please choose an administrative area"), nil}] ++ areas
  end
end
