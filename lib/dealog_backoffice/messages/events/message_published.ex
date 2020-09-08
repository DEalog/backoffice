defmodule DealogBackoffice.Messages.Events.MessagePublished do
  @derive Jason.Encoder
  defstruct [
    :message_id,
    :status,
    :title,
    :body
  ]
end
