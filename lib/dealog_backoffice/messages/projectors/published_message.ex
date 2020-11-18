defmodule DealogBackoffice.Messages.Projectors.PublishedMessage do
  use Commanded.Projections.Ecto,
    application: DealogBackoffice.App,
    name: "Messages.Projectors.PublishedMessage",
    consistency: :strong

  alias DealogBackoffice.Messages.Events.{MessagePublished, MessageUpdated}
  alias DealogBackoffice.Messages.Projections.PublishedMessage

  project(%MessagePublished{} = published, metadata, fn multi ->
    Ecto.Multi.insert(
      multi,
      :create_published_message,
      %PublishedMessage{
        id: published.message_id,
        title: published.title,
        body: published.body,
        category: "Other",
        ars: "059580004004",
        organization: "DEalog Team",
        status: published.status,
        inserted_at: metadata.created_at
      }
    )
  end)

  project(%MessageUpdated{} = updated, metadata, fn multi ->
    changes = [
      title: updated.title,
      body: updated.body,
      category: "Other",
      ars: "059580004004",
      organization: "DEalog Team",
      status: updated.status,
      updated_at: metadata.created_at
    ]

    Ecto.Multi.update_all(multi, :update_published_message, query(updated.message_id),
      set: changes
    )
  end)

  defp query(message_id) do
    from(m in PublishedMessage, where: m.id == ^message_id)
  end
end
