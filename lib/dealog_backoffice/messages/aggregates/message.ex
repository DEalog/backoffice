defmodule DealogBackoffice.Messages.Aggregates.Message do
  defstruct [
    :message_id,
    :title,
    :body,
    :status
  ]

  alias DealogBackoffice.Messages.Aggregates.Message
  alias DealogBackoffice.Messages.Commands.CreateMessage
  alias DealogBackoffice.Messages.Events.MessageCreated

  def execute(%Message{message_id: nil}, %CreateMessage{} = create) do
    %MessageCreated{
      message_id: create.message_id,
      title: create.title,
      body: create.body,
      status: create.status
    }
  end

  def apply(%Message{} = message, %MessageCreated{} = created) do
    %Message{
      message
      | message_id: created.message_id,
        title: created.title,
        body: created.body,
        status: created.status
    }
  end
end
