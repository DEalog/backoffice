defmodule DealogBackoffice.Messages.Projectors.PublishedMessage do
  use Commanded.Projections.Ecto,
    application: DealogBackoffice.App,
    name: "Messages.Projectors.PublishedMessage",
    consistency: :strong

  require Logger

  alias DealogBackoffice.Messages.Events.{MessagePublished, MessageUpdated, MessageArchived}
  alias DealogBackoffice.Messages.Projections.PublishedMessage

  project(%MessagePublished{} = published, metadata, fn multi ->
    Logger.debug("Projecting published event to published messages", %{id: published.message_id})

    Ecto.Multi.insert(
      multi,
      :create_published_message,
      %PublishedMessage{
        id: published.message_id,
        title: published.title,
        body: published.body,
        category: published.category,
        author: get_author(metadata),
        ars: get_in(metadata, ["organization", "administrative_area_id"]) || "000000000000",
        organization: get_in(metadata, ["organization", "name"]) || "DEalog System",
        status: published.status,
        inserted_at: metadata.created_at
      }
    )
  end)

  project(%MessageUpdated{} = updated, metadata, fn multi ->
    Logger.debug("Projecting updated event to published messages", %{id: updated.message_id})

    changes = [
      title: updated.title,
      body: updated.body,
      category: updated.category,
      author: get_author(metadata),
      ars: get_in(metadata, ["organization", "administrative_area_id"]) || "000000000000",
      organization: get_in(metadata, ["organization", "name"]) || "DEalog System",
      status: updated.status,
      updated_at: metadata.created_at
    ]

    Ecto.Multi.update_all(multi, :update_published_message, query(updated.message_id),
      set: changes
    )
  end)

  project(%MessageArchived{} = archived, fn multi ->
    Ecto.Multi.delete_all(multi, :archive_message, query(archived.message_id))
  end)

  defp query(message_id) do
    from(m in PublishedMessage, where: m.id == ^message_id)
  end

  defp get_author(%{"author" => %{"first_name" => first_name, "last_name" => last_name}}) do
    "#{first_name} #{last_name}"
  end

  defp get_author(_), do: "Unbekannter Benutzer"
end
