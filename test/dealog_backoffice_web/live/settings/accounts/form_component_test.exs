defmodule DealogBackofficeWeb.SettingsLive.Accounts.FormComponentTest do
  use DealogBackofficeWeb.ConnCase

  import Phoenix.LiveViewTest

  alias DealogBackoffice.Accounts
  alias DealogBackofficeWeb.SettingsLive.Accounts.FormData

  test "renders the form with the user_id set" do
    user_id = UUID.uuid4()

    rendered =
      render_component(
        DealogBackofficeWeb.SettingsLive.Accounts.FormComponent,
        id: :new,
        action: :an_action,
        changeset: create_account_changeset(user_id),
        administrative_areas: ["option 1"],
        return_to: "/path"
      )

    assert rendered =~ user_id
  end

  defp create_account_changeset(user_id) do
    user_id
    |> Accounts.new_account()
    |> FormData.changeset_for_account()
  end
end
