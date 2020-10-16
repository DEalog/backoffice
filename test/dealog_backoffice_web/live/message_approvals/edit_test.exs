defmodule DealogBackofficeWeb.MessageApprovalsLive.EditTest do
  use DealogBackofficeWeb.ConnCase

  import Phoenix.LiveViewTest

  alias DealogBackoffice.Messages

  setup :register_and_log_in_user

  describe "Approve message" do
    setup [:prepare_message_for_approval]

    test "should render form", %{conn: conn, message_for_approval: message_for_approval} do
      {:ok, view, _} = live(conn, "/approvals/#{message_for_approval.id}/approve")
      rendered = render(view)
      assert rendered =~ "Note"
      assert rendered =~ "Message approval"
    end

    test "should approve a message", %{conn: conn, message_for_approval: message_for_approval} do
      {:ok, view, _} = live(conn, "/approvals/#{message_for_approval.id}/approve")

      result =
        view
        |> element("form")
        |> render_submit(%{message: %{note: ""}})

      assert {_, {:live_redirect, %{to: redirect_path}}} = result
      assert redirect_path == "/approvals/#{message_for_approval.id}"
    end

    test "should approve a message with a note", %{
      conn: conn,
      message_for_approval: message_for_approval
    } do
      {:ok, view, _} = live(conn, "/approvals/#{message_for_approval.id}/approve")

      result =
        view
        |> element("form")
        |> render_submit(%{message: %{note: "A note"}})

      assert {_, {:live_redirect, %{to: redirect_path}}} = result
      assert redirect_path == "/approvals/#{message_for_approval.id}"
    end
  end

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

      assert {_, {:live_redirect, %{to: redirect_path}}} = result
      assert redirect_path == "/approvals/#{message_for_approval.id}"
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

      assert {_, {:live_redirect, %{to: redirect_path}}} = result
      assert redirect_path == "/approvals/#{message_for_approval.id}"
    end
  end

  describe "Publish message" do
    setup [:prepare_message_for_approval]

    test "should redirect to index if message cannot be found", %{conn: conn} do
      missing_id = "140a7443-ac44-4343-86af-ec23a0f36017"

      assert {:error, {:live_redirect, %{flash: flash_token, to: "/approvals"}}} =
               live(conn, "/approvals/#{missing_id}/publish")

      assert %{"not_found_error" => _} = get_flash_from_token(@endpoint, flash_token)
    end

    test "should redirect to message details if message cannot be transitioned", %{
      conn: conn,
      message_for_approval: message_for_approval
    } do
      assert {:error, {:live_redirect, %{flash: flash_token, to: redirect_path}}} =
               live(conn, "/approvals/#{message_for_approval.id}/publish")

      assert redirect_path == "/approvals/#{message_for_approval.id}"
      assert %{"save_error" => _} = get_flash_from_token(@endpoint, flash_token)
    end

    test "should publish a message", %{conn: conn, message_for_approval: message_for_approval} do
      {:ok, view, _} = live(conn, "/approvals/#{message_for_approval.id}/approve")

      view
      |> element("form")
      |> render_submit(%{message: %{note: "A note"}})

      # TODO How can we assert the flash with this approach? It's the same result as above so ambiguous.
      assert {:error, {:live_redirect, %{flash: flash_token, to: redirect_path}}} =
               live(conn, "/approvals/#{message_for_approval.id}/publish")

      assert redirect_path == "/approvals"
      assert %{"save_success" => _} = get_flash_from_token(@endpoint, flash_token)
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
