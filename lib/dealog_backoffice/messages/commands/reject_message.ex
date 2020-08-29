defmodule DealogBackoffice.Messages.Commands.RejectMessage do
  defstruct message_id: "",
            status: :rejected

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
end

