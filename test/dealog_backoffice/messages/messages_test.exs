defmodule DealogBackoffice.MessagesTest do
  use DealogBackoffice.DataCase

  alias DealogBackoffice.Messages
  alias DealogBackoffice.Messages.Projections.Message

  @valid_data %{title: "The title", body: "The body"}
  @invalid_data %{title: nil, body: nil}

  describe "create message" do
    @tag :integration
    test "should succeed with valid data" do
      assert {:ok, %Message{} = message} = Messages.create_message(@valid_data)
      assert message.title == @valid_data.title
      assert message.body == @valid_data.body
    end

    @tag :integration
    test "should fail with invalid data" do
      assert {:error, {:validation_failure, errors}} = Messages.create_message(@invalid_data)
      assert %{title: _, body: _} = errors
    end
  end

  describe "change message" do
    @valid_update_data %{title: "An updated title", body: "An updated body"}
    @invalid_update_data %{title: nil, body: nil}

    @tag :integration
    test "should succeed with valid data" do
      {:ok, %Message{} = message} = Messages.create_message(@valid_data)
      {:ok, %Message{} = updated_message} = Messages.change_message(message, @valid_update_data)

      refute updated_message == message
      assert updated_message.title == @valid_update_data.title
      assert updated_message.body == @valid_update_data.body
    end

    @tag :integration
    test "should succeed but not change if input is same as original" do
      {:ok, %Message{} = message} = Messages.create_message(@valid_data)
      {:ok, %Message{} = updated_message} = Messages.change_message(message, @valid_data)

      assert updated_message == message
    end

    @tag :integration
    test "should fail with invalid data" do
      {:ok, %Message{} = message} = Messages.create_message(@valid_data)

      assert {:error, {:validation_failure, errors}} =
               Messages.change_message(message, @invalid_update_data)

      assert %{title: _, body: _} = errors
    end
  end

  describe "send message for approval" do
    test "should succeed" do
      {:ok, %Message{} = message} = Messages.create_message(@valid_data)
      {:ok, %Message{} = sent_message} = Messages.send_message_for_approval(message)

      assert message.status == "draft"
      assert sent_message.status == "waiting_for_approval"
    end
  end
end
