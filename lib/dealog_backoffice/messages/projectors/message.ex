defmodule DealogBackoffice.Messages.Projectors.Message do
  use Commanded.Projections.Ecto,
    application: DealogBackoffice.App,
    name: "Messages.Projectors.Message",
    consistency: :strong

  require Logger

  alias DealogBackoffice.Messages.Events.{
    MessageCreated,
    MessageChanged,
    MessageSentForApproval,
    MessageDeleted,
    MessageApproved,
    MessageRejected,
    MessagePublished,
    MessageUpdated,
    MessageArchived,
    ChangeDiscarded
  }

  alias DealogBackoffice.Messages.Projections.Message

  project(%MessageCreated{} = created, metadata, fn multi ->
    Logger.debug("Projecting created event to messages", %{id: created.message_id})

    Ecto.Multi.insert(
      multi,
      :message,
      %Message{
        id: created.message_id,
        title: created.title,
        body: created.body,
        category: created.category,
        status: created.status,
        author: get_author(metadata),
        inserted_at: metadata.created_at,
        updated_at: metadata.created_at
      }
    )
  end)

  project(%MessageChanged{} = changed, metadata, fn multi ->
    Logger.debug("Projecting changed event to messages", %{id: changed.message_id})

    update_message(multi, changed.message_id,
      title: changed.title,
      body: changed.body,
      category: changed.category,
      status: changed.status,
      author: get_author(metadata),
      updated_at: metadata.created_at
    )
  end)

  project(%MessageSentForApproval{} = sent_for_approval, metadata, fn multi ->
    Logger.debug("Projecting sent_for_approval event to messages", %{
      id: sent_for_approval.message_id
    })

    update_message(multi, sent_for_approval.message_id,
      title: sent_for_approval.title,
      body: sent_for_approval.body,
      category: sent_for_approval.category,
      status: sent_for_approval.status,
      updated_at: metadata.created_at
    )
  end)

  project(%MessageDeleted{} = deleted, fn multi ->
    Logger.debug("Projecting deleted event to messages", %{id: deleted.message_id})
    Ecto.Multi.delete_all(multi, :delete_message, query(deleted.message_id))
  end)

  project(%MessageArchived{} = archived, fn multi ->
    Logger.debug("Projecting archived event to messages", %{id: archived.message_id})
    Ecto.Multi.delete_all(multi, :archive_message, query(archived.message_id))
  end)

  project(%MessageApproved{} = approved, metadata, fn multi ->
    Logger.debug("Projecting approved event to messages", %{id: approved.message_id})

    update_message(multi, approved.message_id,
      status: approved.status,
      updated_at: metadata.created_at
    )
  end)

  project(%MessageRejected{} = rejected, metadata, fn multi ->
    Logger.debug("Projecting rejected event to messages", %{id: rejected.message_id})

    update_message(multi, rejected.message_id,
      status: rejected.status,
      rejection_reason: rejected.reason,
      updated_at: metadata.created_at
    )
  end)

  project(%MessagePublished{} = published, metadata, fn multi ->
    Logger.debug("Projecting published event to messages", %{id: published.message_id})

    update_message(multi, published.message_id,
      status: published.status,
      published: true,
      updated_at: metadata.created_at
    )
  end)

  project(%MessageUpdated{} = updated, metadata, fn multi ->
    Logger.debug("Projecting updated event to messages", %{id: updated.message_id})

    update_message(multi, updated.message_id,
      status: updated.status,
      updated_at: metadata.created_at
    )
  end)

  project(%ChangeDiscarded{} = discarded, metadata, fn multi ->
    Logger.debug("Projecting discarded event to messages", %{id: discarded.message_id})

    update_message(multi, discarded.message_id,
      title: discarded.title,
      body: discarded.body,
      category: discarded.category,
      status: discarded.status,
      # TODO Revert the date?
      updated_at: metadata.created_at
    )
  end)

  defp update_message(multi, message_id, changes) do
    Ecto.Multi.update_all(multi, :message, query(message_id), set: changes)
  end

  defp query(message_id) do
    from(m in Message, where: m.id == ^message_id)
  end

  defp get_author(%{"author" => %{"first_name" => first_name, "last_name" => last_name}}) do
    "#{first_name} #{last_name}"
  end

  defp get_author(_), do: "Unbekannter Benutzer"
end
