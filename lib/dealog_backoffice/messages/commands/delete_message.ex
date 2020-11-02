defmodule DealogBackoffice.Messages.Commands.DeleteMessage do
  defstruct message_id: "",
            status: :deleted

  use ExConstructor
  use Vex.Struct

  alias DealogBackoffice.Messages.Commands.DeleteMessage
  alias DealogBackoffice.Messages.Projections.Message

  validates(:message_id, uuid: true)

  validates(:status,
    inclusion: [in: [:deleted]]
  )

  def assign_message_id(%DeleteMessage{} = message, %Message{id: message_id}) do
    %DeleteMessage{message | message_id: message_id}
  end

  def set_status(%DeleteMessage{} = message) do
    %DeleteMessage{message | status: :deleted}
  end
end
