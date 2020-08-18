defmodule DealogBackoffice.Messages.Aggregates.MessageTest do
  use DealogBackoffice.AggregateCase, aggregate: DealogBackoffice.Messages.Aggregates.Message

  alias DealogBackoffice.Messages.Commands.{CreateMessage, ChangeMessage}
  alias DealogBackoffice.Messages.Events.{MessageCreated, MessageChanged}

  describe "create message" do
    @tag :unit
    test "should successfully build when valid" do
      message_id = UUID.uuid4()

      assert_events(
        struct(CreateMessage, %{message_id: message_id, title: "A title", body: "A body"}),
        [
          %MessageCreated{
            message_id: message_id,
            status: :draft,
            title: "A title",
            body: "A body"
          }
        ]
      )
    end
  end

  describe "change message" do
    @tag :unit
    test "should successfully build when valid" do
      message_id = UUID.uuid4()

      assert_events(
        [
          %MessageCreated{
            message_id: message_id,
            status: :draft,
            title: "A title",
            body: "A body"
          }
        ],
        struct(ChangeMessage, %{
          message_id: message_id,
          title: "A changed title",
          body: "A changed body"
        }),
        [
          %MessageChanged{
            message_id: message_id,
            status: :draft,
            title: "A changed title",
            body: "A changed body"
          }
        ]
      )
    end
  end
end
