defmodule DealogBackoffice.Messages.Aggregates.Message do
  defstruct [
    :id,
    :title,
    :body
  ]

  alias DealogBackoffice.Messages.Aggregates.Message
  alias DealogBackoffice.Messages.Commands.CreateMessage
  alias DealogBackoffice.Messages.Events.MessageCreated

  def execute(%Message{id: nil}, %CreateMessage{} = create) do
    %MessageCreated{
      message_id: create.message_id,
      title: create.title,
      body: create.body
    }
  end

  def apply(%Message{} = message, %MessageCreated{} = created) do
    %Message{
      message
      | id: created.message_id,
        title: created.title,
        body: created.title
    }
  end
end
