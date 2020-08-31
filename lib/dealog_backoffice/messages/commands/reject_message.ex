defmodule DealogBackoffice.Messages.Commands.RejectMessage do
  defstruct message_id: "",
            status: :rejected,
            reason: nil

  use ExConstructor
  use Vex.Struct

  alias DealogBackoffice.Messages.Commands.RejectMessage
  alias DealogBackoffice.Messages.Projections.MessageForApproval

  validates(:message_id, uuid: true)

  validates(:status,
    inclusion: [in: [:rejected]]
  )

  def assign_message_id(%RejectMessage{} = message, %MessageForApproval{id: message_id}) do
    %RejectMessage{message | message_id: message_id}
  end

  def set_status(%RejectMessage{} = message) do
    %RejectMessage{message | status: :rejected}
  end

  def maybe_set_reason(%RejectMessage{} = message, ""), do: message

  def maybe_set_reason(%RejectMessage{} = message, reason) do
    %RejectMessage{message | reason: reason}
  end
end

