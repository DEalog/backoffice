defmodule DealogBackoffice.Messages.Events.MessageChanged do
  @derive Jason.Encoder
  defstruct [
    :message_id,
    :title,
    :body,
    :status
  ]
end
