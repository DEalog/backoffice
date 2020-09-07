defmodule DealogBackoffice.Messages.Events.MessageSentForApproval do
  @derive Jason.Encoder
  defstruct [
    :message_id,
    :title,
    :body,
    :status
  ]

  defimpl Commanded.Event.Upcaster, for: __MODULE__ do
    alias DealogBackoffice.Messages.Events.MessageSentForApproval

    def upcast(%MessageSentForApproval{status: "waiting_for_approval"} = event, _metadata) do
      %MessageSentForApproval{event | status: :waiting_for_approval}
    end
  end
end
