defmodule DealogBackoffice.Messages.Projectors.MessageApproval do
  use Commanded.Projections.Ecto,
    application: DealogBackoffice.App,
    name: "Messages.Projectors.MessageApproval",
    consistency: :strong

  alias DealogBackoffice.Messages.Events.MessageSentForApproval
  alias DealogBackoffice.Messages.Projections.MessageForApproval
  alias DealogBackoffice.Messages

  project(%MessageSentForApproval{} = sent, metadata, fn multi ->
    case Messages.get_message_for_approval(sent.message_id) do
      {:ok, message_approval} ->
        update_message_approval(multi, message_approval,
          title: sent.title,
          body: sent.body,
          status: sent.status,
          updated_at: NaiveDateTime.utc_now()
        )

      {:error, _} ->
        create_message_approval(multi, sent, metadata)
    end
  end)

  defp update_message_approval(multi, original_message_approval, changes) do
    Ecto.Multi.update_all(multi, :update_message_approval, original_message_approval, set: changes)
  end

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
