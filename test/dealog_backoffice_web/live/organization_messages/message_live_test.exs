defmodule DealogBackofficeWeb.NewMessageLiveTest do
  use DealogBackofficeWeb.ConnCase

  import Phoenix.LiveViewTest

  describe "Create new message" do
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

      result =
        view
        |> element("form")
        |> render_submit(%{message: %{title: "A title", body: "A body"}})

      assert {_, {:live_redirect, %{to: "/organization-messages"}}} = result
    end
  end
end
