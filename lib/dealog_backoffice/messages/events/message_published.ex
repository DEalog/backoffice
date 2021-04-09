defmodule DealogBackoffice.Messages.Events.MessagePublished do
  @derive Jason.Encoder
  defstruct [
    :message_id,
    :status,
    :title,
    :body,
    :category
  ]

  defimpl Commanded.Event.Upcaster, for: __MODULE__ do
    alias DealogBackoffice.Messages.Events.MessagePublished

    def upcast(%MessagePublished{status: "published", category: nil} = event, _metadata) do
      %MessagePublished{event | status: :published, category: "Other"}
    end

    def upcast(%MessagePublished{status: "published"} = event, _metadata) do
      %MessagePublished{event | status: :published}
    end
  end
end
