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

    def upcast(%MessageCreated{status: "draft", author_id: ""} = event, _metadata) do
      %MessageCreated{
        event
        | status: :draft,
          author_first_name: "Unbekannter",
          author_last_name: "Benutzer",
          author_email: "system@dealog.de",
          administrative_area_id: "000000000000",
          organization: "DEalog System"
      }
    end
  end
end
