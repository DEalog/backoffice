defmodule DealogBackoffice.Messages.Events.MessageArchived do
  @derive Jason.Encoder
  defstruct [
    :message_id,
    :title,
    :body,
    :category,
    :status
  ]

  defimpl Commanded.Event.Upcaster, for: __MODULE__ do
    alias DealogBackoffice.Messages.Events.MessageArchived

    def upcast(%MessageArchived{status: "archived", category: nil} = event, _metadata) do
      %MessageArchived{event | status: :archived, category: "Other"}
    end

    def upcast(%MessageArchived{status: "archived"} = event, _metadata) do
      %MessageArchived{event | status: :archived}
    end
  end
end
