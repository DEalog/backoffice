defmodule DealogBackofficeWeb.AllMessagesLive.IndexTest do
  use DealogBackofficeWeb.ConnCase

  import Phoenix.LiveViewTest

  alias DealogBackoffice.Messages

  setup :register_log_in_and_setup_user

  describe "empty list" do
    test "disconnected and connected render", %{conn: conn} do
      {:ok, page_live, disconnected_html} = live(conn, "/all-messages")
      assert disconnected_html =~ "All messages"
      assert render(page_live) =~ "All messages"
      refute disconnected_html =~ "The title"
    end
  end

  describe "non empty list" do
    setup [:prepare_published_message]

    test "should render a list of published messages", %{conn: conn, published_message: message} do
      {:ok, _, html} = live(conn, "/all-messages")
      assert html =~ message.title
    end
  end

  @valid_attrs %{
    title: "The title",
    body: "The body"
  }

  defp fixture(:message, user) do
    {:ok, message} = Messages.create_message(user, @valid_attrs)
    {:ok, message} = Messages.send_message_for_approval(user, message)
    {:ok, message_for_approval} = Messages.get_message_for_approval(message.id)
    {:ok, approved_message} = Messages.approve_message(user, message_for_approval)
    {:ok, published_message} = Messages.publish_message(user, approved_message)
    published_message
  end

  defp prepare_published_message(%{user: user}) do
    {:ok, published_message: fixture(:message, user)}
  end
end
