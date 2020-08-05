defmodule DealogBackoffice.Router do
  use Commanded.Commands.Router

  alias DealogBackoffice.Messages.Aggregates.Message
  alias DealogBackoffice.Messages.Commands.CreateMessage

  identify(Message, by: :message_id, prefix: "message-")

  dispatch([CreateMessage], to: Message)
end
