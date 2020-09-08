defmodule DealogBackoffice.Messages.Projectors.PublishedMessage do
  use Commanded.Projections.Ecto,
    application: DealogBackoffice.App,
    name: "Messages.Projectors.PublishedMessage",
    consistency: :strong

  alias DealogBackoffice.Messages.Events.MessagePublished

  alias DealogBackoffice.Messages.Projections.PublishedMessage

  project(%MessagePublished{} = published, metadata, fn multi ->
    Ecto.Multi.insert(
      multi,
      :published_message,
      %PublishedMessage{
        id: published.message_id,
        title: published.title,
        body: published.body,
        status: published.status,
        inserted_at: metadata.created_at
      }
    )
  end)
end
