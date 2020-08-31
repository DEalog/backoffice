defmodule DealogBackofficeWeb.OrganizationMessagesLive.MessageLiveTest do
  use DealogBackofficeWeb.ConnCase

  import Phoenix.LiveViewTest

  alias DealogBackoffice.Messages

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

  describe "Change existing message" do
    setup [:create_message]

    test "should render form", %{conn: conn, message: message} do
      {:ok, view, _} = live(conn, "/organization-messages/#{message.id}/change")
      rendered = render(view)
      assert rendered =~ message.title
      assert rendered =~ message.body
      assert rendered =~ "Change message"
    end

    test "should change a message", %{conn: conn, message: message} do
      {:ok, view, _} = live(conn, "/organization-messages/#{message.id}/change")

      result =
        view
        |> element("form")
        |> render_submit(%{message: %{title: "A changed title", body: "A change body"}})

      assert {_, {:live_redirect, %{to: "/organization-messages"}}} = result
    end
  end

  @valid_attrs %{title: "The title", body: "The body"}

  defp fixture(:message) do
    {:ok, message} = Messages.create_message(@valid_attrs)
    message
  end

  defp create_message(_) do
    message = fixture(:message)
    {:ok, message: message}
  end
end
