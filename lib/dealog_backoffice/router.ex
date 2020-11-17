defmodule DealogBackoffice.Router do
  @moduledoc """
  Router for directing the events to the respective aggregates.

  Further the router registers used middlewares like for validation.
  """
  use Commanded.Commands.Router

  alias DealogBackoffice.Accounts.Aggregates.Account

  alias DealogBackoffice.Accounts.Commands.{
    CreateAccount,
    ChangePersonalData,
    ChangeOrganizationalSettings
  }

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

  alias DealogBackoffice.Middlewares.{Log, Validate}

  middleware(Log)
  middleware(Validate)

  # Account

  identify(Account, by: :account_id, prefix: "account-")

  dispatch([CreateAccount, ChangePersonalData, ChangeOrganizationalSettings], to: Account)

  # Message

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
