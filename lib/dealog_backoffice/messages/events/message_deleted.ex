defmodule DealogBackoffice.Messages.Events.MessageDeleted do
  @derive Jason.Encoder
  defstruct [
    :message_id,
    :title,
    :body,
    :status
  ]
end
