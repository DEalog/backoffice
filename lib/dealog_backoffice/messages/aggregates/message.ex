defmodule DealogBackoffice.Messages.Aggregates.Message do
  defstruct [
    :message_id,
    :title,
    :body,
    :status
  ]

  alias DealogBackoffice.Messages.Aggregates.Message
  alias DealogBackoffice.Messages.Commands.{CreateMessage, ChangeMessage, SendMessageForApproval}
  alias DealogBackoffice.Messages.Events.{MessageCreated, MessageChanged, MessageSentForApproval}

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
end
