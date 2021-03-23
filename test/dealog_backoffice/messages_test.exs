defmodule DealogBackoffice.MessagesTest do
  use DealogBackoffice.DataCase

  import DealogBackoffice.MessageTestHelpers

  alias DealogBackoffice.Messages

  alias DealogBackoffice.Messages.Projections.{
    Message,
    MessageForApproval,
    DeletedMessage,
    PublishedMessage,
    ArchivedMessage
  }

  @valid_data %{title: "The title", body: "The body"}
  @invalid_data %{title: nil, body: nil}

  describe "create message" do
    setup [:user]

    @tag :integration
    test "should succeed with valid data", %{user: user} do
      assert {:ok, %Message{} = message} = Messages.create_message(user, @valid_data)
      assert message.title == @valid_data.title
      assert message.body == @valid_data.body
    end

    @tag :integration
    test "should fail with invalid data", %{user: user} do
      assert {:error, {:validation_failure, errors}} =
               Messages.create_message(user, @invalid_data)

      assert %{title: _, body: _} = errors
    end
  end

  describe "change message" do
    @valid_update_data %{title: "An updated title", body: "An updated body"}
    @invalid_update_data %{title: nil, body: nil}

    setup [:user, :newly_created_message]

    @tag :integration
    test "should succeed with valid data", %{user: user, created_message: message} do
      {:ok, %Message{} = updated_message} =
        Messages.change_message(user, message, @valid_update_data)

      refute updated_message == message
      assert updated_message.title == @valid_update_data.title
      assert updated_message.body == @valid_update_data.body
    end

    @tag :integration
    test "should succeed but not change if input is same as original", %{
      user: user,
      created_message: message
    } do
      {:ok, %Message{} = updated_message} = Messages.change_message(user, message, @valid_data)

      assert updated_message == message
    end

    @tag :integration
    test "should fail with invalid data", %{user: user, created_message: message} do
      assert {:error, {:validation_failure, errors}} =
               Messages.change_message(user, message, @invalid_update_data)

      assert %{title: _, body: _} = errors
    end
  end

  describe "send message for approval" do
    setup [:user, :newly_created_message]

    @tag :integration
    test "should succeed if in status draft", %{user: user, created_message: message} do
      assert {:ok, %Message{} = sent_message} = Messages.send_message_for_approval(user, message)
      assert message.status == :draft
      assert sent_message.status == :waiting_for_approval
    end

    @tag :integration
    test "should fail when not in draft", %{user: user} do
      message_in_approval = fixture(:message_in_approval, user)
      {:ok, sent_message} = Messages.get_message(message_in_approval.id)

      assert {:error, :invalid_transition} =
               Messages.send_message_for_approval(user, sent_message)
    end
  end

  describe "delete message" do
    setup [:user]

    @tag :integration
    test "should succeed if in status draft", %{user: user} do
      message = fixture(:created_message, user)
      assert message.status == :draft

      assert {:ok, %DeletedMessage{} = deleted_message} =
               Messages.delete_message(user, message.id)

      assert {:error, :not_found} = Messages.get_message(message.id)
      assert deleted_message.status == :deleted
    end

    @tag :integration
    test "should fail when not in draft", %{user: user} do
      message_in_approval = fixture(:message_in_approval, user)
      assert {:error, :invalid_transition} = Messages.delete_message(user, message_in_approval.id)
    end
  end

  describe "approve message" do
    setup [:user, :message_in_approval]

    @tag :integration
    test "should succeed without adding a note", %{user: user, message_in_approval: message} do
      assert message.status == :waiting_for_approval

      assert {:ok, %MessageForApproval{} = approved_message} =
               Messages.approve_message(user, message)

      assert approved_message.status == :approved
    end

    @tag :integration
    test "should succeed with a note attached", %{user: user, message_in_approval: message} do
      assert message.status == :waiting_for_approval

      assert {:ok, %MessageForApproval{} = approved_message} =
               Messages.approve_message(user, message, "A note")

      assert approved_message.status == :approved
      assert approved_message.note == "A note"
    end

    @tag :integration
    test "should fail when not in status waiting for approval", %{user: user} do
      approved_message = fixture(:approved_message, user)

      assert {:error, :invalid_transition} = Messages.approve_message(user, approved_message)
    end
  end

  describe "reject message" do
    setup [:user, :message_in_approval]

    @tag :integration
    test "should succeed without giving a reason", %{user: user, message_in_approval: message} do
      assert message.status == :waiting_for_approval

      assert {:ok, %Message{} = rejected_message} = Messages.reject_message(user, message)

      assert rejected_message.status == :rejected
    end

    @tag :integration
    test "should succeed with a reason attached", %{user: user, message_in_approval: message} do
      assert message.status == :waiting_for_approval

      assert {:ok, %Message{} = rejected_message} =
               Messages.reject_message(user, message, "A reason")

      assert rejected_message.status == :rejected
      assert rejected_message.rejection_reason == "A reason"
    end
  end

  describe "publish message" do
    setup [:user, :approved_message]

    @tag :integration
    test "should succeed", %{user: user, approved_message: message} do
      assert {:ok, %PublishedMessage{} = published_message} =
               Messages.publish_message(user, message)

      assert published_message.title == @valid_data.title
      assert published_message.body == @valid_data.body
      assert published_message.status == :published
    end
  end

  describe "archive message" do
    setup [:user, :published_message]

    @tag :integration
    test "should succeed", %{published_message: message} do
      {:ok, %ArchivedMessage{} = archived_message} = Messages.archive_message(message.id)

      assert archived_message.title == @valid_data.title
      assert archived_message.body == @valid_data.body
      assert archived_message.status == :archived
    end
  end

  describe "discard change" do
    setup [:user, :published_message]

    @tag :integration
    test "should succeed", %{user: user, published_message: message} do
      {:ok, %Message{} = loaded_message} = Messages.get_message(message.id)

      {:ok, %Message{} = updated_message} =
        Messages.change_message(user, loaded_message, %{
          title: "Changed title",
          body: "Changed body"
        })

      {:ok, %Message{} = reverted_message} = Messages.discard_change(updated_message.id)

      assert reverted_message.title == @valid_data.title
      assert reverted_message.body == @valid_data.body
      assert reverted_message.status == :published
    end
  end

  describe "discard change and archive" do
    setup [:user, :published_message]

    @tag :integration
    test "should succeed", %{user: user, published_message: message} do
      {:ok, %Message{} = loaded_message} = Messages.get_message(message.id)

      {:ok, %Message{} = updated_message} =
        Messages.change_message(user, loaded_message, %{
          title: "Changed title",
          body: "Changed body"
        })

      {:ok, %ArchivedMessage{} = reverted_message} =
        Messages.discard_change_and_archive(updated_message.id)

      assert reverted_message.title == @valid_data.title
      assert reverted_message.body == @valid_data.body
      assert reverted_message.status == :archived
    end
  end

  defp fixture(:user), do: build_user()

  defp fixture(:created_message, user) do
    {:ok, %Message{} = message} = Messages.create_message(user, @valid_data)

    message
  end

  defp fixture(:message_in_approval, user) do
    message = fixture(:created_message, user)
    {:ok, %Message{} = message} = Messages.send_message_for_approval(user, message)
    {:ok, %MessageForApproval{} = message} = Messages.get_message_for_approval(message.id)

    message
  end

  defp fixture(:approved_message, user) do
    message = fixture(:created_message, user)
    {:ok, %Message{} = message} = Messages.send_message_for_approval(user, message)
    {:ok, %MessageForApproval{} = message} = Messages.get_message_for_approval(message.id)

    {:ok, %MessageForApproval{} = message} =
      Messages.approve_message(user, message, "Approval granted")

    message
  end

  defp fixture(:published_message, user) do
    message = fixture(:created_message, user)
    {:ok, %Message{} = message} = Messages.send_message_for_approval(user, message)
    {:ok, %MessageForApproval{} = message} = Messages.get_message_for_approval(message.id)

    {:ok, %MessageForApproval{} = message} =
      Messages.approve_message(user, message, "Approval granted")

    {:ok, %PublishedMessage{} = message} = Messages.publish_message(user, message)

    message
  end

  defp user(_) do
    %{user: fixture(:user)}
  end

  defp newly_created_message(%{user: user}) do
    %{created_message: fixture(:created_message, user)}
  end

  defp message_in_approval(%{user: user}) do
    %{message_in_approval: fixture(:message_in_approval, user)}
  end

  defp approved_message(%{user: user}) do
    %{approved_message: fixture(:approved_message, user)}
  end

  defp published_message(%{user: user}) do
    %{published_message: fixture(:published_message, user)}
  end
end
