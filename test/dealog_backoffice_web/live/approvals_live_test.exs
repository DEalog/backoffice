defmodule DealogBackofficeWeb.ApprovalsLiveTest do
  use DealogBackofficeWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Approvals"
    assert render(page_live) =~ "Approvals"
  end
end
