defmodule DealogBackoffice.Messages.Projectors.Message do
  use Commanded.Projections.Ecto,
    application: DealogBackoffice.App,
    name: "Messages.Projectors.Message",
    consistency: :strong

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
    multi
    |> Ecto.Multi.insert(
      :message,
      %Message{
        id: created.message_id,
        title: created.title,
        body: created.body,
        status: created.status,
        inserted_at: metadata.created_at,
        updated_at: metadata.created_at
      }
    )
    |> Ecto.Multi.insert(:message_change, fn %{message: message} ->
      author = metadata["author"] || get_fallback_author()

      %Message.Change{
        id: UUID.uuid4(),
        action: "create",
        author: build_author(author),
        organization: build_organization(author),
        message: message,
        inserted_at: metadata.created_at
      }
    end)
  end)

  project(%MessageChanged{} = changed, metadata, fn multi ->
    update_message(multi, changed.message_id,
      title: changed.title,
      body: changed.body,
      status: changed.status,
      updated_at: metadata.created_at
    )
  end)

  project(%MessageSentForApproval{} = sent_for_approval, metadata, fn multi ->
    update_message(multi, sent_for_approval.message_id,
      title: sent_for_approval.title,
      body: sent_for_approval.body,
      status: sent_for_approval.status,
      updated_at: metadata.created_at
    )
  end)

  project(%MessageDeleted{} = deleted, fn multi ->
    Ecto.Multi.delete_all(multi, :delete_message, query(deleted.message_id))
  end)

  project(%MessageArchived{} = archived, fn multi ->
    Ecto.Multi.delete_all(multi, :archive_message, query(archived.message_id))
  end)

  project(%MessageApproved{} = approved, metadata, fn multi ->
    update_message(multi, approved.message_id,
      status: approved.status,
      updated_at: metadata.created_at
    )
  end)

  project(%MessageRejected{} = rejected, metadata, fn multi ->
    update_message(multi, rejected.message_id,
      status: rejected.status,
      rejection_reason: rejected.reason,
      updated_at: metadata.created_at
    )
  end)

  project(%MessagePublished{} = published, metadata, fn multi ->
    update_message(multi, published.message_id,
      status: published.status,
      published: true,
      updated_at: metadata.created_at
    )
  end)

  project(%MessageUpdated{} = updated, metadata, fn multi ->
    update_message(multi, updated.message_id,
      status: updated.status,
      updated_at: metadata.created_at
    )
  end)

  project(%ChangeDiscarded{} = discarded, metadata, fn multi ->
    update_message(multi, discarded.message_id,
      title: discarded.title,
      body: discarded.body,
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

  defp get_fallback_author() do
    %{
      "id" => nil,
      "first_name" => "Unbekannter",
      "last_name" => "Benutzer",
      "email" => "system@dealog.de",
      "position" => "",
      "administrative_area_id" => "000000000000",
      "organization" => "DEalog Team"
    }
  end

  defp build_author(author) do
    %Message.Change.Author{
      id: author["id"],
      name: "#{author["first_name"]} #{author["last_name"]}",
      email: author["email"],
      position: author["position"]
    }
  end

  defp build_organization(author) do
    %Message.Change.Organization{
      name: author["organization"],
      administrative_area_id: author["administrative_area_id"]
    }
  end
end
