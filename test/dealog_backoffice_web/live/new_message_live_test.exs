defmodule DealogBackofficeWeb.NewMessageLiveTest do
  use DealogBackofficeWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/organization-messages/new")
    assert disconnected_html =~ "New message"
    assert render(page_live) =~ "New message"
  end
end
