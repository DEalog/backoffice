defmodule DealogBackofficeWeb.NewMessageLiveTest do
  use DealogBackofficeWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, view, html} = live(conn, "/organization-messages/new")
    assert html =~ "New message"
    assert render(view) =~ "New message"
  end

  test "should render form", %{conn: conn} do
    {:ok, view, _} = live(conn, "/organization-messages/new")
    rendered = render(view)
    assert rendered =~ "Title"
    assert rendered =~ "Body"
    assert rendered =~ "Create new message"
  end

  test "should create a new message", %{conn: conn} do
    {:ok, view, _} = live(conn, "/organization-messages/new")

    assert {_, {:live_redirect, %{to: "/organization-messages"}}} =
             render_submit(view, :create_message, %{message: %{title: "A title", body: "A body"}})
  end
end
