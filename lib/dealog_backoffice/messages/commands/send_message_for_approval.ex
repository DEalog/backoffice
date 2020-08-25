defmodule DealogBackoffice.Messages.Commands.SendMessageForApproval do
  defstruct message_id: "",
            title: "",
            body: "",
            status: :waiting_for_approval

  use ExConstructor
  use Vex.Struct

  alias DealogBackoffice.Messages.Commands.SendMessageForApproval
  alias DealogBackoffice.Messages.Projections.Message

  validates(:message_id, uuid: true)

  validates(:title,
    presence: [message: "can't be blank"],
    string: true
  )

  validates(:body,
    presence: [message: "can't be blank"],
    string: true
  )

  validates(:status,
    inclusion: [in: [:waiting_for_approval]]
  )

  def assign_message_id(%SendMessageForApproval{} = message, %Message{id: message_id}) do
    %SendMessageForApproval{message | message_id: message_id}
  end

  def set_status(%SendMessageForApproval{} = message) do
    %SendMessageForApproval{message | status: :waiting_for_approval}
  end
end
