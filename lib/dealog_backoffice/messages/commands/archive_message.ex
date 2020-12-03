defmodule DealogBackoffice.Messages.Commands.ArchiveMessage do
  defstruct message_id: "",
            status: :archived

  use ExConstructor
  use Vex.Struct

  alias DealogBackoffice.Messages.Commands.ArchiveMessage
  alias DealogBackoffice.Messages.Projections.Message

  validates(:message_id, uuid: true)

  validates(:status,
    inclusion: [in: [:archived]]
  )

  def assign_message_id(%ArchiveMessage{} = message, %Message{id: message_id}) do
    %ArchiveMessage{message | message_id: message_id}
  end

  def set_status(%ArchiveMessage{} = message) do
    %ArchiveMessage{message | status: :archived}
  end
end
