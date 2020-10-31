defmodule DealogBackofficeWeb.SettingsLive.IndexTest do
  use DealogBackofficeWeb.ConnCase

  import Phoenix.LiveViewTest

  setup :register_and_log_in_user

  describe "Show settings" do
    test "renders settings page", %{conn: conn} do
      user = get_user_from_session(conn)
      {:ok, view, html} = live(conn, "/settings")
      assert html =~ "Settings"
      assert render(view) =~ "Settings"
      assert html =~ "Users"
      assert html =~ "Confirmed"
      assert view |> element("td>div>div", user.email) |> has_element?()
    end

    test "redirects if user is not logged in" do
      conn = build_conn()
      {:error, {:redirect, %{to: path}}} = live(conn, "/settings")
      assert path == Routes.user_session_path(conn, :new)
    end
  end
end
