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
    test "should succeed with valid data", %{user: user, message: message} do
      {:ok, %Message{} = updated_message} =
        Messages.change_message(user, message, @valid_update_data)

      refute updated_message == message
      assert updated_message.title == @valid_update_data.title
      assert updated_message.body == @valid_update_data.body
    end

    @tag :integration
    test "should succeed but not change if input is same as original", %{
      user: user,
      message: message
    } do
      {:ok, %Message{} = updated_message} = Messages.change_message(user, message, @valid_data)

      assert updated_message == message
    end

    @tag :integration
    test "should fail with invalid data", %{user: user, message: message} do
      assert {:error, {:validation_failure, errors}} =
               Messages.change_message(user, message, @invalid_update_data)

      assert %{title: _, body: _} = errors
    end
  end

  describe "send message for approval" do
    setup [:user, :newly_created_message]

    @tag :integration
    test "should succeed if in status draft", %{user: user, message: message} do
      assert {:ok, %Message{} = sent_message} = Messages.send_message_for_approval(user, message)
      assert message.status == :draft
      assert sent_message.status == :waiting_for_approval
    end

    @tag :integration
    test "should fail when not in draft", %{user: user, message: message} do
      {:ok, %Message{} = sent_message} = Messages.send_message_for_approval(user, message)

      assert {:error, :invalid_transition} =
               Messages.send_message_for_approval(user, sent_message)
    end
  end

  describe "delete message" do
    setup [:user, :newly_created_message]

    @tag :integration
    test "should succeed if in status draft", %{message: message} do
      assert message.status == :draft
      assert {:ok, %DeletedMessage{} = deleted_message} = Messages.delete_message(message.id)
      assert {:error, :not_found} = Messages.get_message(message.id)
      assert deleted_message.status == :deleted
    end

    @tag :integration
    test "should fail when not in draft", %{user: user, message: message} do
      {:ok, %Message{} = sent_message} = Messages.send_message_for_approval(user, message)

      assert {:error, :invalid_transition} = Messages.delete_message(sent_message.id)
    end
  end

  describe "approve message" do
    setup [:user, :newly_created_message]

    @tag :integration
    test "should succeed without adding a note", %{user: user, message: message} do
      Messages.send_message_for_approval(user, message)

      {:ok, %MessageForApproval{} = message_for_approval} =
        Messages.get_message_for_approval(message.id)

      assert message_for_approval.status == :waiting_for_approval

      assert {:ok, %MessageForApproval{} = approved_message} =
               Messages.approve_message(message_for_approval)

      assert approved_message.status == :approved
    end

    @tag :integration
    test "should succeed with a note attached", %{user: user, message: message} do
      Messages.send_message_for_approval(user, message)

      {:ok, %MessageForApproval{} = message_for_approval} =
        Messages.get_message_for_approval(message.id)

      assert message_for_approval.status == :waiting_for_approval

      assert {:ok, %MessageForApproval{} = approved_message} =
               Messages.approve_message(message_for_approval, "A note")

      assert approved_message.status == :approved
      assert approved_message.note == "A note"
    end

    @tag :integration
    test "should fail when not in status waiting for approval", %{user: user, message: message} do
      Messages.send_message_for_approval(user, message)

      {:ok, %MessageForApproval{} = message_for_approval} =
        Messages.get_message_for_approval(message.id)

      {:ok, %MessageForApproval{} = approved_message} =
        Messages.approve_message(message_for_approval)

      assert {:error, :invalid_transition} = Messages.approve_message(approved_message)
    end
  end

  describe "reject message" do
    setup [:user, :newly_created_message]

    @tag :integration
    test "should succeed without giving a reason", %{user: user, message: message} do
      Messages.send_message_for_approval(user, message)

      {:ok, %MessageForApproval{} = message_for_approval} =
        Messages.get_message_for_approval(message.id)

      assert message_for_approval.status == :waiting_for_approval

      assert {:ok, %Message{} = rejected_message} = Messages.reject_message(message_for_approval)

      assert rejected_message.status == :rejected
    end

    @tag :integration
    test "should succeed with a reason attached", %{user: user, message: message} do
      Messages.send_message_for_approval(user, message)

      {:ok, %MessageForApproval{} = message_for_approval} =
        Messages.get_message_for_approval(message.id)

      assert message_for_approval.status == :waiting_for_approval

      assert {:ok, %Message{} = rejected_message} =
               Messages.reject_message(message_for_approval, "A reason")

      assert rejected_message.status == :rejected
      assert rejected_message.rejection_reason == "A reason"
    end
  end

  describe "publish message" do
    setup [:user, :newly_created_message]

    @tag :integration
    test "should succeed", %{user: user, message: message} do
      with {:ok, _} = Messages.send_message_for_approval(user, message),
           {:ok, message_for_approval} = Messages.get_message_for_approval(message.id),
           {:ok, approved_message} = Messages.approve_message(message_for_approval) do
        assert {:ok, %PublishedMessage{} = published_message} =
                 Messages.publish_message(approved_message)

        assert published_message.title == @valid_data.title
        assert published_message.body == @valid_data.body
        assert published_message.status == :published
      end
    end
  end

  describe "archive message" do
    setup [:user, :newly_created_message]

    @tag :integration
    test "should succeed", %{user: user, message: message} do
      with {:ok, _} = Messages.send_message_for_approval(user, message),
           {:ok, message_for_approval} = Messages.get_message_for_approval(message.id),
           {:ok, approved_message} = Messages.approve_message(message_for_approval),
           {:ok, %PublishedMessage{} = published_message} =
             Messages.publish_message(approved_message) do
        {:ok, %ArchivedMessage{} = archived_message} =
          Messages.archive_message(published_message.id)

        assert archived_message.title == @valid_data.title
        assert archived_message.body == @valid_data.body
        assert archived_message.status == :archived
      end
    end
  end

  describe "discard change" do
    setup [:user, :newly_created_message]

    @tag :integration
    test "should succeed", %{user: user, message: message} do
      with {:ok, _} <- Messages.send_message_for_approval(user, message),
           {:ok, message_for_approval} <- Messages.get_message_for_approval(message.id),
           {:ok, approved_message} <- Messages.approve_message(message_for_approval),
           {:ok, %PublishedMessage{} = published_message} <-
             Messages.publish_message(approved_message) do
        {:ok, %Message{} = loaded_message} = Messages.get_message(published_message.id)

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
  end

  describe "discard change and archive" do
    setup [:user, :newly_created_message]

    @tag :integration
    test "should succeed", %{user: user, message: message} do
      with {:ok, _} <- Messages.send_message_for_approval(user, message),
           {:ok, message_for_approval} <- Messages.get_message_for_approval(message.id),
           {:ok, approved_message} <- Messages.approve_message(message_for_approval),
           {:ok, %PublishedMessage{} = published_message} <-
             Messages.publish_message(approved_message) do
        {:ok, %Message{} = loaded_message} = Messages.get_message(published_message.id)

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
  end

  defp user(_) do
    %{user: build_user()}
  end

  defp newly_created_message(%{user: user}) do
    {:ok, %Message{} = message} = Messages.create_message(user, @valid_data)
    %{message: message}
  end
end
