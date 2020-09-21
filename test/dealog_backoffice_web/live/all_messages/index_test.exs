defmodule DealogBackofficeWeb.AllMessagesLive.IndexTest do
  use DealogBackofficeWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/all-messages")
    assert disconnected_html =~ "All messages"
    assert render(page_live) =~ "All messages"
  end
end
