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
  def execute(%Message{message_id: message_id, status: :draft}, %SendMessageForApproval{} = send) do
    %MessageSentForApproval{
      message_id: message_id,
      title: send.title,
      body: send.body,
      status: send.status
    }
  end

  def execute(%Message{}, %SendMessageForApproval{}), do: {:error, :invalid_state}

  @doc """
  Delete an existing message.
  """
  def execute(
        %Message{message_id: message_id, status: :draft} = message,
        %DeleteMessage{} = delete
      ) do
    %MessageDeleted{
      message_id: message_id,
      title: message.title,
      body: message.body,
      status: delete.status
    }
  end

  def execute(%Message{}, %DeleteMessage{}), do: {:error, :invalid_state}

  @doc """
  Approve an existing message.
  """
  def execute(
        %Message{message_id: message_id, status: :waiting_for_approval},
        %ApproveMessage{} = approve
      ) do
    %MessageApproved{
      message_id: message_id,
      status: approve.status,
      note: approve.note
    }
  end

  def execute(%Message{}, %ApproveMessage{}), do: {:error, :invalid_state}

  @doc """
  Reject an existing message.
  """
  def execute(
        %Message{message_id: message_id, status: :waiting_for_approval},
        %RejectMessage{} = reject
      ) do
    %MessageRejected{
      message_id: message_id,
      status: reject.status,
      reason: reject.reason
    }
  end

  def execute(%Message{}, %RejectMessage{}), do: {:error, :invalid_state}

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

  def apply(%Message{} = message, %MessageDeleted{} = deleted) do
    %Message{
      message
      | message_id: deleted.message_id,
        title: deleted.title,
        body: deleted.body,
        status: deleted.status
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
