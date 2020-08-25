defmodule DealogBackoffice.Messages.Events.MessageSentForApproval do
  @derive Jason.Encoder
  defstruct [
    :message_id,
    :title,
    :body,
    :status
  ]
end
