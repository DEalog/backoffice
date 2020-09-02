defmodule DealogBackoffice.Messages.Aggregates.Message do
  defstruct [
    :message_id,
    :title,
    :body,
    :status,
    :approval_notes,
    :rejection_reasons
  ]

  alias DealogBackoffice.Messages.Aggregates.Message

  alias DealogBackoffice.Messages.Commands.{
    CreateMessage,
    ChangeMessage,
    SendMessageForApproval,
    ApproveMessage,
    RejectMessage
  }

  alias DealogBackoffice.Messages.Events.{
    MessageCreated,
    MessageChanged,
    MessageSentForApproval,
    MessageApproved,
    MessageRejected
  }

  @doc """
  Create a new message.
  """
  def execute(%Message{message_id: nil}, %CreateMessage{} = create) do
    %MessageCreated{
      message_id: create.message_id,
      title: create.title,
      body: create.body,
      status: create.status
    }
  end

  @doc """
  Change an existing message.
  """
  def execute(%Message{message_id: message_id}, %ChangeMessage{} = change) do
    %MessageChanged{
      message_id: message_id,
      title: change.title,
      body: change.body,
      status: change.status
    }
  end

  @doc """
  Send an existing message for approval.
  """
  def execute(%Message{message_id: message_id}, %SendMessageForApproval{} = send) do
    %MessageSentForApproval{
      message_id: message_id,
      title: send.title,
      body: send.body,
      status: send.status
    }
  end

  @doc """
  Approve an existing message.
  """
  def execute(%Message{message_id: message_id}, %ApproveMessage{} = approve) do
    %MessageApproved{
      message_id: message_id,
      status: approve.status,
      note: approve.note
    }
  end

  @doc """
  Reject an existing message.
  """
  def execute(%Message{message_id: message_id}, %RejectMessage{} = reject) do
    %MessageRejected{
      message_id: message_id,
      status: reject.status,
      reason: reject.reason
    }
  end

  # State mutators for reconstitution

  def apply(%Message{} = message, %MessageCreated{} = created) do
    %Message{
      message
      | message_id: created.message_id,
        title: created.title,
        body: created.body,
        status: created.status
    }
  end

  def apply(%Message{} = message, %MessageChanged{} = changed) do
    %Message{
      message
      | message_id: changed.message_id,
        title: changed.title,
        body: changed.body,
        status: changed.status
    }
  end

  def apply(%Message{} = message, %MessageSentForApproval{} = sent) do
    %Message{
      message
      | message_id: sent.message_id,
        title: sent.title,
        body: sent.body,
        status: sent.status
    }
  end

  def apply(%Message{} = message, %MessageApproved{} = approved) do
    %Message{
      message
      | message_id: approved.message_id,
        status: approved.status,
        approval_notes: message.approval_notes || [] ++ [approved.note]
    }
  end

  def apply(%Message{} = message, %MessageRejected{} = rejected) do
    %Message{
      message
      | message_id: rejected.message_id,
        status: rejected.status,
        rejection_reasons: message.rejection_reasons || [] ++ [rejected.reason]
    }
  end
end
