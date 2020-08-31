defmodule DealogBackofficeWeb.MessageApprovalsLive.MessageTest do
  use DealogBackofficeWeb.ConnCase

  import Phoenix.LiveViewTest

  alias DealogBackoffice.Messages

  describe "Reject message" do
    setup [:prepare_message_for_approval]

    test "should render form", %{conn: conn, message_for_approval: message_for_approval} do
      {:ok, view, _} = live(conn, "/approvals/#{message_for_approval.id}/reject")
      rendered = render(view)
      assert rendered =~ "Reason"
      assert rendered =~ "Message rejection"
    end

    test "should reject a message", %{conn: conn, message_for_approval: message_for_approval} do
      {:ok, view, _} = live(conn, "/approvals/#{message_for_approval.id}/reject")

      result =
        view
        |> element("form")
        |> render_submit(%{message: %{reason: ""}})

      assert {_, {:live_redirect, %{to: "/approvals"}}} = result
    end

    test "should reject a message with a reason", %{
      conn: conn,
      message_for_approval: message_for_approval
    } do
      {:ok, view, _} = live(conn, "/approvals/#{message_for_approval.id}/reject")

      result =
        view
        |> element("form")
        |> render_submit(%{message: %{reason: "A reason"}})

      assert {_, {:live_redirect, %{to: "/approvals"}}} = result
    end
  end

  @valid_attrs %{
    title: "The title",
    body: "The body"
  }

  defp fixture(:message) do
    {:ok, message} = Messages.create_message(@valid_attrs)
    message
  end

  defp prepare_message_for_approval(_) do
    message = fixture(:message)
    Messages.send_message_for_approval(message)
    {:ok, message_for_approval} = Messages.get_message_for_approval(message.id)
    {:ok, message_for_approval: message_for_approval}
  end
end
