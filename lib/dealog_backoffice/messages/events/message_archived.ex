defmodule DealogBackoffice.Messages.Events.MessageArchived do
  @derive Jason.Encoder
  defstruct [
    :message_id,
    :title,
    :body,
    :status
  ]
end
