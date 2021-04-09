defmodule DealogBackoffice.Messages.Events.MessageCreated do
  @derive Jason.Encoder
  defstruct [
    :message_id,
    :title,
    :body,
    :category,
    :status
  ]

  defimpl Commanded.Event.Upcaster, for: __MODULE__ do
    alias DealogBackoffice.Messages.Events.MessageCreated

    def upcast(%MessageCreated{status: "draft", category: nil} = event, _metadata) do
      %MessageCreated{
        event
        | status: :draft,
          category: "Other"
      }
    end

    def upcast(%MessageCreated{status: "draft"} = event, _metadata) do
      %MessageCreated{
        event
        | status: :draft
      }
    end
  end
end
