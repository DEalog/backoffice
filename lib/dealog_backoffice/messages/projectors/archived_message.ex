defmodule DealogBackoffice.Messages.Projectors.ArchivedMessage do
  use Commanded.Projections.Ecto,
    application: DealogBackoffice.App,
    name: "Messages.Projectors.ArchivedMessage",
    consistency: :strong

  alias DealogBackoffice.Messages.Events.MessageArchived

  alias DealogBackoffice.Messages.Projections.ArchivedMessage

  project(%MessageArchived{} = archived, metadata, fn multi ->
    Ecto.Multi.insert(
      multi,
      :archived_message,
      %ArchivedMessage{
        id: archived.message_id,
        title: archived.title,
        body: archived.body,
        status: archived.status,
        inserted_at: metadata.created_at
      }
    )
  end)
end
