defmodule DealogBackoffice.Messages.Events.MessageUpdated do
  @derive Jason.Encoder
  defstruct [
    :message_id,
    :status,
    :title,
    :body
  ]
end
