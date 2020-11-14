defmodule DealogBackoffice.Messages.Events.MessageChanged do
  @derive Jason.Encoder
  defstruct [
    :message_id,
    :title,
    :body,
    :status
  ]

  defimpl Commanded.Event.Upcaster, for: __MODULE__ do
    alias DealogBackoffice.Messages.Events.MessageChanged

    def upcast(%MessageChanged{status: "draft"} = event, _metadata) do
      %MessageChanged{event | status: :draft}
    end
  end
end
