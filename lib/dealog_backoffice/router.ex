defmodule DealogBackoffice.Router do
  @moduledoc """
  Router for directing the events to the respective aggregates.

  Further the router registers used middlewares like for validation.
  """
  use Commanded.Commands.Router

  alias DealogBackoffice.Messages.Aggregates.Message

  alias DealogBackoffice.Messages.Commands.{
    CreateMessage,
    ChangeMessage,
    SendMessageForApproval,
    DeleteMessage,
    ApproveMessage,
    RejectMessage,
    PublishMessage
  }

  alias DealogBackoffice.Middlewares.Validate

  middleware(Validate)

  identify(Message, by: :message_id, prefix: "message-")

  dispatch(
    [
      CreateMessage,
      ChangeMessage,
      SendMessageForApproval,
      DeleteMessage,
      ApproveMessage,
      RejectMessage,
      PublishMessage
    ],
    to: Message
  )
end
