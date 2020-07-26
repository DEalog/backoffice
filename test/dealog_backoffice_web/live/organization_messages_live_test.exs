defmodule DealogBackofficeWeb.OrganizationMessagesLiveTest do
  use DealogBackofficeWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/organization-messages")
    assert disconnected_html =~ "My organization"
    assert render(page_live) =~ "My organization"
  end
end
