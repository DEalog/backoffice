defmodule DealogBackofficeWeb.PageLiveTest do
  use DealogBackofficeWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Übersicht"
    assert render(page_live) =~ "Übersicht"
  end
end
