defmodule DealogBackoffice.Messages.Commands.CreateMessage do
  defstruct message_id: "",
            title: "",
            body: "",
            status: :draft

  use ExConstructor
  use Vex.Struct

  alias DealogBackoffice.Messages.Commands.CreateMessage
  alias DealogBackoffice.Messages.Validators.UniqueMessageId

  validates(:message_id,
    uuid: true,
    by: &UniqueMessageId.validate/2
  )

  validates(:title,
    presence: [message: "can't be blank"],
    string: true
  )

  validates(:body,
    presence: [message: "can't be blank"],
    string: true
  )

  validates(:status,
    inclusion: [in: [:draft]]
  )

  def assign_message_id(%CreateMessage{} = message, uuid) do
    %CreateMessage{message | message_id: uuid}
  end
end
