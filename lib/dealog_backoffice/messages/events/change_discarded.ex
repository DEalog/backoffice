defmodule DealogBackoffice.Messages.Events.ChangeDiscarded do
  @derive Jason.Encoder
  defstruct [
    :message_id,
    :title,
    :body,
    :status
  ]
end
