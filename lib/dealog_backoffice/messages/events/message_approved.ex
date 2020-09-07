defmodule DealogBackoffice.Messages.Events.MessageApproved do
  @derive Jason.Encoder
  defstruct [
    :message_id,
    :status,
    :note
  ]

  defimpl Commanded.Event.Upcaster, for: __MODULE__ do
    alias DealogBackoffice.Messages.Events.MessageApproved

    def upcast(%MessageApproved{status: "approved"} = event, _metadata) do
      %MessageApproved{event | status: :approved}
    end
  end
end
