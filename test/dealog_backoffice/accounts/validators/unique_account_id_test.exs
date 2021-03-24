defmodule DealogBackoffice.Messages.Validators.UniqueMessageIdTest do
  use DealogBackoffice.DataCase

  import DealogBackoffice.MessageTestHelpers

  alias DealogBackoffice.Messages
  alias DealogBackoffice.Messages.Validators.UniqueMessageId

  test "should pass if unique" do
    assert :ok = UniqueMessageId.validate(UUID.uuid4(), %{})
  end

  test "should return error when not unique" do
    user = build_user()

    {:ok, message} = Messages.create_message(user, %{title: "The title", body: "The body"})

    assert {:error, "has already been created"} = UniqueMessageId.validate(message.id, %{})
  end
end
