defmodule DealogBackofficeWeb.DashboardLiveTest do
  use DealogBackofficeWeb.ConnCase

  import Phoenix.LiveViewTest

  setup :register_and_log_in_user

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Dashboard"
    assert render(page_live) =~ "Dashboard"
  end

  test "dashboard sections are present", %{conn: conn} do
    {:ok, page_live, _} = live(conn, "/")
    rendered = render(page_live)
    assert rendered =~ "Dashboard"
    assert rendered =~ "Message overview"
    assert rendered =~ "User behavior"
  end
end
