defmodule DealogBackoffice.Messages.Aggregates.MessageTest do
  use DealogBackoffice.AggregateCase, aggregate: DealogBackoffice.Messages.Aggregates.Message

  alias DealogBackoffice.Messages.Commands.{
    CreateMessage,
    ChangeMessage,
    SendMessageForApproval,
    DeleteMessage,
    ApproveMessage,
    RejectMessage
  }

  alias DealogBackoffice.Messages.Events.{
    MessageCreated,
    MessageChanged,
    MessageSentForApproval,
    MessageDeleted,
    MessageApproved,
    MessageRejected
  }

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

  describe "send message for approval" do
    @tag :unit
    test "should successfully be sent" do
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
        struct(SendMessageForApproval, %{
          message_id: message_id,
          title: "A title",
          body: "A body",
          status: :waiting_for_approval
        }),
        [
          %MessageSentForApproval{
            message_id: message_id,
            status: :waiting_for_approval,
            title: "A title",
            body: "A body"
          }
        ]
      )
    end

    @tag :unit
    test "should fail when not in draft state" do
      message_id = UUID.uuid4()

      assert_error(
        [
          %MessageCreated{
            message_id: message_id,
            status: :draft,
            title: "A title",
            body: "A body"
          },
          %MessageSentForApproval{
            message_id: message_id,
            status: :waiting_for_approval,
            title: "A title",
            body: "A body"
          }
        ],
        struct(SendMessageForApproval, %{
          message_id: message_id,
          title: "A title",
          body: "A body",
          status: :waiting_for_approval
        }),
        {:error, :invalid_state}
      )
    end
  end

  describe "delete message" do
    @tag :unit
    test "should be successfully deleted" do
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
        struct(DeleteMessage, %{
          message_id: message_id,
          status: :deleted
        }),
        [
          %MessageDeleted{
            message_id: message_id,
            title: "A title",
            body: "A body",
            status: :deleted
          }
        ]
      )
    end

    @tag :unit
    test "should be blocked when not in draft" do
      message_id = UUID.uuid4()

      assert_error(
        [
          %MessageCreated{
            message_id: message_id,
            status: :draft,
            title: "A title",
            body: "A body"
          },
          %MessageSentForApproval{
            message_id: message_id,
            status: :sent_for_approval,
            title: "A title",
            body: "A body"
          }
        ],
        struct(DeleteMessage, %{
          message_id: message_id,
          status: :deleted
        }),
        {:error, :invalid_state}
      )
    end
  end

  describe "approve message" do
    @tag :unit
    test "should successfully be approved without note" do
      message_id = UUID.uuid4()

      assert_events(
        [
          %MessageCreated{
            message_id: message_id,
            status: :draft,
            title: "A title",
            body: "A body"
          },
          %MessageSentForApproval{
            message_id: message_id,
            status: :waiting_for_approval,
            title: "A title",
            body: "A body"
          }
        ],
        struct(ApproveMessage, %{
          message_id: message_id
        }),
        [
          %MessageApproved{
            message_id: message_id,
            status: :approved
          }
        ]
      )
    end

    @tag :unit
    test "should successfully be approved with a note" do
      message_id = UUID.uuid4()

      assert_events(
        [
          %MessageCreated{
            message_id: message_id,
            status: :draft,
            title: "A title",
            body: "A body"
          },
          %MessageSentForApproval{
            message_id: message_id,
            status: :waiting_for_approval,
            title: "A title",
            body: "A body"
          }
        ],
        struct(ApproveMessage, %{
          message_id: message_id,
          note: "A note"
        }),
        [
          %MessageApproved{
            message_id: message_id,
            status: :approved,
            note: "A note"
          }
        ]
      )
    end

    @tag :unit
    test "should be rejected when not in state waiting_for_approval" do
      message_id = UUID.uuid4()

      assert_error(
        [
          %MessageCreated{
            message_id: message_id,
            status: :draft,
            title: "A title",
            body: "A body"
          }
        ],
        struct(ApproveMessage, %{
          message_id: message_id
        }),
        {:error, :invalid_state}
      )
    end
  end

  describe "reject message" do
    @tag :unit
    test "should successfully be rejected without reason" do
      message_id = UUID.uuid4()

      assert_events(
        [
          %MessageCreated{
            message_id: message_id,
            status: :draft,
            title: "A title",
            body: "A body"
          },
          %MessageSentForApproval{
            message_id: message_id,
            status: :waiting_for_approval,
            title: "A title",
            body: "A body"
          }
        ],
        struct(RejectMessage, %{
          message_id: message_id
        }),
        [
          %MessageRejected{
            message_id: message_id,
            status: :rejected
          }
        ]
      )
    end

    @tag :unit
    test "should successfully be rejected with reason" do
      message_id = UUID.uuid4()

      assert_events(
        [
          %MessageCreated{
            message_id: message_id,
            status: :draft,
            title: "A title",
            body: "A body"
          },
          %MessageSentForApproval{
            message_id: message_id,
            status: :waiting_for_approval,
            title: "A title",
            body: "A body"
          }
        ],
        struct(RejectMessage, %{
          message_id: message_id,
          reason: "A reason"
        }),
        [
          %MessageRejected{
            message_id: message_id,
            status: :rejected,
            reason: "A reason"
          }
        ]
      )
    end

    test "should be rejected when not in state waiting_for_approval" do
      message_id = UUID.uuid4()

      assert_error(
        [
          %MessageCreated{
            message_id: message_id,
            status: :draft,
            title: "A title",
            body: "A body"
          }
        ],
        struct(RejectMessage, %{
          message_id: message_id
        }),
        {:error, :invalid_state}
      )
    end
  end
end
