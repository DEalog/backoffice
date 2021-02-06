defmodule DealogBackoffice.Messages.Events.MessageCreated do
  @derive Jason.Encoder
  defstruct [
    :message_id,
    :title,
    :body,
    :status,
    :author_id,
    :author_email,
    :author_first_name,
    :author_last_name,
    :administrative_area_id,
    :organization,
    :position
  ]

  defimpl Commanded.Event.Upcaster, for: __MODULE__ do
    alias DealogBackoffice.Messages.Events.MessageCreated

    def upcast(%MessageCreated{status: "draft"} = event, _metadata) do
      %MessageCreated{event | status: :draft}
    end
  end
end
