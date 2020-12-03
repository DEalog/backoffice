defmodule DealogBackoffice.Messages.Commands.DiscardChange do
  defstruct message_id: "",
            title: "",
            body: "",
            status: :published

  use ExConstructor
  use Vex.Struct

  alias DealogBackoffice.Messages.Projections.{Message, PublishedMessage}
  alias DealogBackoffice.Messages.Commands.DiscardChange

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
    inclusion: [in: [:published]]
  )

  def assign_message_id(%DiscardChange{} = message, %Message{id: message_id}) do
    %DiscardChange{message | message_id: message_id}
  end

  def apply_data_from(%DiscardChange{} = change, %PublishedMessage{} = published_message) do
    %DiscardChange{change | title: published_message.title, body: published_message.body}
  end
end
