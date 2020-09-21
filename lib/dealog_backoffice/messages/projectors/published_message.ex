defmodule DealogBackoffice.Messages.Projectors.PublishedMessage do
  use Commanded.Projections.Ecto,
    application: DealogBackoffice.App,
    name: "Messages.Projectors.PublishedMessage",
    consistency: :strong

  alias DealogBackoffice.Messages
  alias DealogBackoffice.Messages.Events.MessagePublished
  alias DealogBackoffice.Messages.Projections.PublishedMessage

  project(%MessagePublished{} = published, metadata, fn multi ->
    case Messages.get_published_message(published.message_id) do
      {:ok, _} ->
        changes = [
          title: published.title,
          body: published.body,
          status: published.status,
          updated_at: NaiveDateTime.utc_now()
        ]

        Ecto.Multi.update_all(multi, :update_published_message, query(published.message_id),
          set: changes
        )

      {:error, _} ->
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
    end
  end)

  defp query(message_id) do
    from(m in PublishedMessage, where: m.id == ^message_id)
  end
end
