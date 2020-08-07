defmodule DealogBackoffice.Router do
  use Commanded.Commands.Router

  alias DealogBackoffice.Messages.Aggregates.Message
  alias DealogBackoffice.Messages.Commands.CreateMessage

  alias DealogBackoffice.Middlewares.Validate

  middleware(Validate)

  identify(Message, by: :message_id, prefix: "message-")

  dispatch([CreateMessage], to: Message)
end
