defmodule DealogBackofficeWeb.MyAccountLiveTest do
  use DealogBackofficeWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/my-account")
    assert disconnected_html =~ "My account"
    assert render(page_live) =~ "My account"
  end
end
