defmodule DealogBackoffice.Messages.Commands.ApproveMessage do
  defstruct message_id: "",
            status: :approved,
            note: nil

  use ExConstructor
  use Vex.Struct

  alias DealogBackoffice.Messages.Commands.ApproveMessage
  alias DealogBackoffice.Messages.Projections.MessageForApproval

  validates(:message_id, uuid: true)

  validates(:status,
    inclusion: [in: [:approved]]
  )

  def assign_message_id(%ApproveMessage{} = message, %MessageForApproval{id: message_id}) do
    %ApproveMessage{message | message_id: message_id}
  end

  def set_status(%ApproveMessage{} = message) do
    %ApproveMessage{message | status: :approved}
  end

  def maybe_set_note(%ApproveMessage{} = message, ""), do: message

  def maybe_set_note(%ApproveMessage{} = message, note) do
    %ApproveMessage{message | note: note}
  end
end

