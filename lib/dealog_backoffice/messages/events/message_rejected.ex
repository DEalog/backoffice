defmodule DealogBackoffice.Messages.Events.MessageRejected do
  @derive Jason.Encoder
  defstruct [
    :message_id,
    :status
  ]
end
