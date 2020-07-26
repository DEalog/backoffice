defmodule DealogBackofficeWeb.SettingsLiveTest do
  use DealogBackofficeWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/settings")
    assert disconnected_html =~ "Settings"
    assert render(page_live) =~ "Settings"
  end
end
