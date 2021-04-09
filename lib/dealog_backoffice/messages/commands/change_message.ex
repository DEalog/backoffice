defmodule DealogBackoffice.Messages.Commands.ChangeMessage do
  defstruct message_id: "",
            title: "",
            body: "",
            category: "",
            status: :draft

  use ExConstructor
  use Vex.Struct

  alias DealogBackoffice.Messages.Projections.Message
  alias DealogBackoffice.Messages.Commands.ChangeMessage

  validates(:message_id, uuid: true)

  validates(:title,
    presence: [message: "can't be blank"],
    string: true
  )

  validates(:body,
    presence: [message: "can't be blank"],
    string: true
  )

  validates(:category,
    presence: [message: "can't be blank"],
    string: true
  )

  validates(:status,
    inclusion: [in: [:draft]]
  )

  def assign_message_id(%ChangeMessage{} = message, %Message{id: message_id}) do
    %ChangeMessage{message | message_id: message_id}
  end
end
