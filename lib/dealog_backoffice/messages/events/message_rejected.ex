defmodule DealogBackoffice.Messages.Events.MessageRejected do
  @derive Jason.Encoder
  defstruct [
    :message_id,
    :status,
    :reason
  ]

  defimpl Commanded.Event.Upcaster, for: __MODULE__ do
    alias DealogBackoffice.Messages.Events.MessageRejected

    def upcast(%MessageRejected{} = event, _metadata) do
      case Map.has_key?(event, :reason) do
        false -> %MessageRejected{event | reason: ""}
        _ -> event
      end
    end

    def upcast(%MessageRejected{status: "rejected"} = event, _metadata) do
      %MessageRejected{event | status: :rejected}
    end
  end
end
