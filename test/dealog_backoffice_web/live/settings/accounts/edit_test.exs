defmodule DealogBackofficeWeb.SettingsLive.Accounts.EditTest do
  use DealogBackofficeWeb.ConnCase

  import Phoenix.LiveViewTest

  setup :register_and_log_in_user

  describe "show edit form for new account" do
    test "renders the form", %{conn: conn} do
      user = get_user_from_session(conn)
      {:ok, view, html} = live(conn, "/settings/accounts/new/#{user.id}")
      assert html =~ "Create new account"
      assert html =~ "Personal data"
      assert html =~ "Organizational settings"
      assert view |> element("#form_data_user_id") |> render() =~ user.id
    end

    test "redirects if user is not logged in" do
      conn = build_conn()
      {:error, {:redirect, %{to: path}}} = live(conn, "/settings/accounts/new/123")
      assert path == Routes.user_session_path(conn, :new)
    end
  end

  describe "show edit form for account change" do
    test "renders the form", %{conn: conn} do
      user = get_user_from_session(conn)
      account = create_account_for_user(user)
      {:ok, view, html} = live(conn, "/settings/accounts/#{account.id}/change")
      assert html =~ "Change account"
      assert html =~ "Personal data"
      assert html =~ "Organizational settings"
      assert view |> element("#form_data_id") |> render() =~ account.id
      assert view |> element("#form_data_user_id") |> render() =~ user.id
    end

    test "redirects if user is not logged in" do
      conn = build_conn()
      {:error, {:redirect, %{to: path}}} = live(conn, "/settings/accounts/123/change")
      assert path == Routes.user_session_path(conn, :new)
    end
  end
end
