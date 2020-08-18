defmodule DealogBackoffice.Messages.Commands.CreateMessage do
  defstruct message_id: "",
            title: "",
            body: "",
            status: :draft

  use ExConstructor
  use Vex.Struct

  alias DealogBackoffice.Messages.Commands.CreateMessage

  validates(:message_id, uuid: true)

  validates(:title,
    presence: [message: "can't be blank"],
    string: true
  )

  validates(:body,
    presence: [message: "can't be blank"],
    string: true
  )

  def assign_uuid(%CreateMessage{} = message, uuid) do
    %CreateMessage{message | message_id: uuid}
  end
end
