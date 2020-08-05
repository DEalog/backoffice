defmodule DealogBackoffice.Messages.Events.MessageCreated do
  @derive Jason.Encoder
  defstruct [
    :message_id,
    :title,
    :body
  ]
end
