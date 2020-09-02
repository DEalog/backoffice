defmodule DealogBackoffice.Messages.Events.MessageApproved do
  @derive Jason.Encoder
  defstruct [
    :message_id,
    :status,
    :note
  ]
end
