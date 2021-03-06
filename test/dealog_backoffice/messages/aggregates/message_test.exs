defmodule DealogBackoffice.Messages.Aggregates.MessageTest do
  use DealogBackoffice.AggregateCase, aggregate: DealogBackoffice.Messages.Aggregates.Message

  alias DealogBackoffice.Messages.Commands.{
    CreateMessage,
    ChangeMessage,
    SendMessageForApproval,
    DeleteMessage,
    ApproveMessage,
    RejectMessage,
    PublishMessage,
    ArchiveMessage,
    DiscardChange
  }

  alias DealogBackoffice.Messages.Events.{
    MessageCreated,
    MessageChanged,
    MessageSentForApproval,
    MessageDeleted,
    MessageApproved,
    MessageRejected,
    MessagePublished,
    MessageUpdated,
    MessageArchived,
    ChangeDiscarded
  }

  describe "create message" do
    @tag :unit
    test "should successfully build when valid" do
      message_id = UUID.uuid4()

      assert_events(
        struct(CreateMessage, %{
          message_id: message_id,
          title: "A title",
          body: "A body",
          category: "A category"
        }),
        [
          %MessageCreated{
            message_id: message_id,
            status: :draft,
            title: "A title",
            body: "A body",
            category: "A category"
          }
        ]
      )
    end

    @tag :unit
    test "should successfully build with valid and additional data" do
      message_id = UUID.uuid4()

      assert_events(
        struct(CreateMessage, %{
          message_id: message_id,
          title: "A title",
          body: "A body",
          category: "A category"
        }),
        [
          %MessageCreated{
            message_id: message_id,
            status: :draft,
            title: "A title",
            body: "A body",
            category: "A category"
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
            body: "A body",
            category: "A category"
          }
        ],
        struct(ChangeMessage, %{
          message_id: message_id,
          title: "A changed title",
          body: "A changed body",
          category: "A changed category"
        }),
        [
          %MessageChanged{
            message_id: message_id,
            status: :draft,
            title: "A changed title",
            body: "A changed body",
            category: "A changed category"
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
            body: "A body",
            category: "A category"
          }
        ],
        struct(SendMessageForApproval, %{
          message_id: message_id,
          title: "A title",
          body: "A body",
          category: "A category",
          status: :waiting_for_approval
        }),
        [
          %MessageSentForApproval{
            message_id: message_id,
            status: :waiting_for_approval,
            title: "A title",
            body: "A body",
            category: "A category"
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
            body: "A body",
            category: "A category"
          },
          %MessageSentForApproval{
            message_id: message_id,
            status: :waiting_for_approval,
            title: "A title",
            body: "A body",
            category: "A category"
          }
        ],
        struct(SendMessageForApproval, %{
          message_id: message_id,
          title: "A title",
          body: "A body",
          category: "A category",
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
            body: "A body",
            category: "A category"
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
            category: "A category",
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
            body: "A body",
            category: "A category"
          },
          %MessageSentForApproval{
            message_id: message_id,
            status: :sent_for_approval,
            title: "A title",
            body: "A body",
            category: "A category"
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
            body: "A body",
            category: "A category"
          },
          %MessageSentForApproval{
            message_id: message_id,
            status: :waiting_for_approval,
            title: "A title",
            body: "A body",
            category: "A category"
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
            body: "A body",
            category: "A category"
          },
          %MessageSentForApproval{
            message_id: message_id,
            status: :waiting_for_approval,
            title: "A title",
            body: "A body",
            category: "A category"
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
            body: "A body",
            category: "A category"
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
            body: "A body",
            category: "A category"
          },
          %MessageSentForApproval{
            message_id: message_id,
            status: :waiting_for_approval,
            title: "A title",
            body: "A body",
            category: "A category"
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
            body: "A body",
            category: "A category"
          },
          %MessageSentForApproval{
            message_id: message_id,
            status: :waiting_for_approval,
            title: "A title",
            body: "A body",
            category: "A category"
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
            body: "A body",
            category: "A category"
          }
        ],
        struct(RejectMessage, %{
          message_id: message_id
        }),
        {:error, :invalid_state}
      )
    end
  end

  describe "publish message" do
    @tag :unit
    test "should successfully be published when approved" do
      message_id = UUID.uuid4()

      assert_events(
        [
          %MessageCreated{
            message_id: message_id,
            status: :draft,
            title: "A title",
            body: "A body",
            category: "A category"
          },
          %MessageSentForApproval{
            message_id: message_id,
            status: :waiting_for_approval,
            title: "A title",
            body: "A body",
            category: "A category"
          },
          %MessageApproved{
            message_id: message_id,
            status: :approved
          }
        ],
        struct(PublishMessage, %{
          message_id: message_id
        }),
        [
          %MessagePublished{
            message_id: message_id,
            status: :published,
            title: "A title",
            body: "A body",
            category: "A category"
          }
        ]
      )
    end

    @tag :unit
    test "should be rejected when not in state approved" do
      message_id = UUID.uuid4()

      assert_error(
        [
          %MessageCreated{
            message_id: message_id,
            status: :draft,
            title: "A title",
            body: "A body",
            category: "A category"
          }
        ],
        struct(PublishMessage, %{
          message_id: message_id
        }),
        {:error, :invalid_state}
      )
    end

    @tag :unit
    test "should successfully be updated when already published" do
      message_id = UUID.uuid4()

      assert_events(
        [
          %MessageCreated{
            message_id: message_id,
            status: :draft,
            title: "A title",
            body: "A body",
            category: "A category"
          },
          %MessageSentForApproval{
            message_id: message_id,
            status: :waiting_for_approval,
            title: "A title",
            body: "A body",
            category: "A category"
          },
          %MessageApproved{
            message_id: message_id,
            status: :approved
          },
          %MessagePublished{
            message_id: message_id,
            status: :published,
            title: "A title",
            body: "A body",
            category: "A category"
          },
          %MessageChanged{
            message_id: message_id,
            status: :draft,
            title: "A changed title",
            body: "A changed body",
            category: "A changed category"
          },
          %MessageSentForApproval{
            message_id: message_id,
            status: :waiting_for_approval,
            title: "A changed title",
            body: "A changed body",
            category: "A changed category"
          },
          %MessageApproved{
            message_id: message_id,
            status: :approved
          }
        ],
        struct(PublishMessage, %{
          message_id: message_id
        }),
        [
          %MessageUpdated{
            message_id: message_id,
            status: :published,
            title: "A changed title",
            body: "A changed body",
            category: "A changed category"
          }
        ]
      )
    end
  end

  describe "archive message" do
    @tag :unit
    test "should successfully be archived when published" do
      message_id = UUID.uuid4()

      assert_events(
        [
          %MessageCreated{
            message_id: message_id,
            status: :draft,
            title: "A title",
            body: "A body",
            category: "A category"
          },
          %MessageSentForApproval{
            message_id: message_id,
            status: :waiting_for_approval,
            title: "A title",
            body: "A body",
            category: "A category"
          },
          %MessageApproved{
            message_id: message_id,
            status: :approved
          },
          %MessagePublished{
            message_id: message_id,
            title: "A title",
            body: "A body",
            category: "A category"
          }
        ],
        struct(ArchiveMessage, %{
          message_id: message_id
        }),
        [
          %MessageArchived{
            message_id: message_id,
            status: :archived,
            title: "A title",
            body: "A body",
            category: "A category"
          }
        ]
      )
    end

    @tag :unit
    test "should be rejected when not in state published" do
      message_id = UUID.uuid4()

      assert_error(
        [
          %MessageCreated{
            message_id: message_id,
            status: :draft,
            title: "A title",
            body: "A body",
            category: "A category"
          }
        ],
        struct(ArchiveMessage, %{
          message_id: message_id
        }),
        {:error, :invalid_state}
      )
    end
  end

  describe "discard change" do
    @tag :unit
    test "should successfully be archived when published" do
      message_id = UUID.uuid4()

      assert_events(
        [
          %MessageCreated{
            message_id: message_id,
            status: :draft,
            title: "A title",
            body: "A body",
            category: "A category"
          },
          %MessageSentForApproval{
            message_id: message_id,
            status: :waiting_for_approval,
            title: "A title",
            body: "A body",
            category: "A category"
          },
          %MessageApproved{
            message_id: message_id,
            status: :approved
          },
          %MessagePublished{
            message_id: message_id,
            title: "A title",
            body: "A body",
            category: "A category"
          },
          %MessageChanged{
            message_id: message_id,
            title: "A changed title",
            body: "A changed body",
            category: "A changed category"
          }
        ],
        struct(DiscardChange, %{
          message_id: message_id,
          title: "A title",
          body: "A body",
          category: "A category"
        }),
        [
          %ChangeDiscarded{
            message_id: message_id,
            status: :published,
            title: "A title",
            body: "A body",
            category: "A category"
          }
        ]
      )
    end

    @tag :unit
    test "should be rejected when not in state published" do
      message_id = UUID.uuid4()

      assert_error(
        [
          %MessageCreated{
            message_id: message_id,
            status: :draft,
            title: "A title",
            body: "A body",
            category: "A category"
          }
        ],
        struct(DiscardChange, %{
          message_id: message_id,
          title: "A title",
          body: "A body",
          category: "A category"
        }),
        {:error, :invalid_state}
      )
    end
  end
end
