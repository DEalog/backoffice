defmodule DealogBackoffice.Messages.Events.MessageUpdated do
  @derive Jason.Encoder
  defstruct [
    :message_id,
    :status,
    :title,
    :category,
    :body
  ]

  defimpl Commanded.Event.Upcaster, for: __MODULE__ do
    alias DealogBackoffice.Messages.Events.MessageUpdated

    def upcast(%MessageUpdated{status: "published", category: nil} = event, _metadata) do
      %MessageUpdated{event | status: :published, category: "Other"}
    end

    def upcast(%MessageUpdated{status: "published"} = event, _metadata) do
      %MessageUpdated{event | status: :published}
    end
  end
end
