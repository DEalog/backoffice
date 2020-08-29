defmodule DealogBackoffice.Messages.Projectors.MessageApproval do
  use Commanded.Projections.Ecto,
    application: DealogBackoffice.App,
    name: "Messages.Projectors.MessageApproval",
    consistency: :strong

  alias DealogBackoffice.Messages.Events.{MessageSentForApproval, MessageRejected}
  alias DealogBackoffice.Messages.Projections.MessageForApproval
  alias DealogBackoffice.Messages

  project(%MessageSentForApproval{} = sent, metadata, fn multi ->
    case Messages.get_message_for_approval(sent.message_id) do
      {:ok, _} ->
        update_message_approval(multi, sent.message_id,
          title: sent.title,
          body: sent.body,
          status: sent.status,
          updated_at: NaiveDateTime.utc_now()
        )

      {:error, _} ->
        create_message_approval(multi, sent, metadata)
    end
  end)

  project(%MessageRejected{} = rejected, metadata, fn multi ->
    update_message_approval(multi, rejected.message_id,
      status: rejected.status,
      updated_at: metadata.created_at
    )
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
        inserted_at: metadata.created_at
      }
    )
  end
end
