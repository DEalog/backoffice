defmodule DealogBackoffice.Messages.Commands.PublishMessage do
  defstruct message_id: "",
            status: :published

  use ExConstructor
  use Vex.Struct

  alias DealogBackoffice.Messages.Commands.PublishMessage
  alias DealogBackoffice.Messages.Projections.MessageForApproval

  validates(:message_id, uuid: true)

  validates(:status,
    inclusion: [in: [:published]]
  )

  def assign_message_id(%PublishMessage{} = message, %MessageForApproval{id: message_id}) do
    %PublishMessage{message | message_id: message_id}
  end

  def set_status(%PublishMessage{} = message) do
    %PublishMessage{message | status: :published}
  end
end
