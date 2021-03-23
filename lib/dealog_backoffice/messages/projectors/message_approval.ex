defmodule DealogBackoffice.Messages.Projectors.MessageApproval do
  use Commanded.Projections.Ecto,
    application: DealogBackoffice.App,
    name: "Messages.Projectors.MessageApproval",
    consistency: :strong

  alias DealogBackoffice.Messages.Events.{
    MessageSentForApproval,
    MessageApproved,
    MessageRejected,
    MessagePublished,
    MessageUpdated
  }

  alias DealogBackoffice.Messages.Projections.MessageForApproval
  alias DealogBackoffice.Messages

  project(%MessageSentForApproval{} = sent, metadata, fn multi ->
    case Messages.get_message_for_approval(sent.message_id) do
      {:ok, _} ->
        update_message_approval(multi, sent.message_id,
          title: sent.title,
          body: sent.body,
          status: sent.status,
          author: get_author(metadata),
          updated_at: metadata.created_at
        )

      {:error, _} ->
        create_message_approval(multi, sent, metadata)
    end
  end)

  project(%MessageApproved{} = approved, metadata, fn multi ->
    update_message_approval(multi, approved.message_id,
      status: approved.status,
      note: approved.note,
      author: get_author(metadata),
      updated_at: metadata.created_at
    )
  end)

  project(%MessageRejected{} = rejected, fn multi ->
    Ecto.Multi.delete_all(multi, :remove_rejected_message, query(rejected.message_id))
  end)

  project(%MessagePublished{} = published, fn multi ->
    Ecto.Multi.delete_all(multi, :remove_published_message, query(published.message_id))
  end)

  project(%MessageUpdated{} = updated, fn multi ->
    Ecto.Multi.delete_all(multi, :remove_updated_message, query(updated.message_id))
  end)

  defp update_message_approval(multi, message_id, changes) do
    Ecto.Multi.update_all(multi, :update_message_approval, query(message_id), set: changes)
  end

  defp query(message_id) do
    from(m in MessageForApproval, where: m.id == ^message_id)
  end

  # Create a new message approval
  defp create_message_approval(multi, sent, metadata) do
    Ecto.Multi.insert(
      multi,
      :insert_or_update_message,
      %MessageForApproval{
        id: sent.message_id,
        title: sent.title,
        body: sent.body,
        status: sent.status,
        author: get_author(metadata),
        inserted_at: metadata.created_at,
        updated_at: metadata.created_at
      }
    )
  end

  defp get_author(%{"author" => %{"first_name" => first_name, "last_name" => last_name}}) do
    "#{first_name} #{last_name}"
  end

  defp get_author(_), do: "Unbekannter Benutzer"
end
