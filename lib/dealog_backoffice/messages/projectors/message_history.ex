defmodule DealogBackoffice.Messages.Projectors.MessageHistory do
  use Commanded.Projections.Ecto,
    application: DealogBackoffice.App,
    name: "Messages.Projectors.MessageHistory",
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

  alias DealogBackoffice.Messages.Projections.MessageChange

  project(%MessageCreated{} = created, metadata, fn multi ->
    Logger.debug("Projecting created event to history", %{id: created.message_id})
    Ecto.Multi.insert(multi, :message_change, build_message_change("create", created, metadata))
  end)

  project(%MessageChanged{} = changed, metadata, fn multi ->
    Ecto.Multi.insert(multi, :message_change, build_message_change("change", changed, metadata))
  end)

  project(%MessageSentForApproval{} = sent_for_approval, metadata, fn multi ->
    Ecto.Multi.insert(
      multi,
      :message_change,
      build_message_change("send_for_approval", sent_for_approval, metadata)
    )
  end)

  project(%MessageDeleted{} = deleted, metadata, fn multi ->
    Ecto.Multi.insert(multi, :message_change, build_message_change("delete", deleted, metadata))
  end)

  project(%MessageArchived{} = archived, metadata, fn multi ->
    Ecto.Multi.insert(multi, :message_change, build_message_change("archive", archived, metadata))
  end)

  project(%MessageApproved{} = approved, metadata, fn multi ->
    Ecto.Multi.insert(multi, :message_change, build_message_change("approve", approved, metadata))
  end)

  project(%MessageRejected{} = rejected, metadata, fn multi ->
    Ecto.Multi.insert(multi, :message_change, build_message_change("reject", rejected, metadata))
  end)

  project(%MessagePublished{} = published, metadata, fn multi ->
    Ecto.Multi.insert(
      multi,
      :message_change,
      build_message_change("publish", published, metadata)
    )
  end)

  project(%MessageUpdated{} = updated, metadata, fn multi ->
    Ecto.Multi.insert(multi, :message_change, build_message_change("publish", updated, metadata))
  end)

  project(%ChangeDiscarded{} = discarded, metadata, fn multi ->
    Ecto.Multi.insert(multi, :message_change, build_message_change("change", discarded, metadata))
  end)

  defp build_message_change(action, event, metadata) do
    author = metadata["author"] || get_fallback_author()

    %MessageChange{
      id: UUID.uuid4(),
      action: action,
      author: build_author(author),
      organization: build_organization(author),
      message_id: event.message_id,
      inserted_at: metadata.created_at
    }
  end

  defp get_fallback_author() do
    %{
      "id" => nil,
      "first_name" => "Unbekannter",
      "last_name" => "Benutzer",
      "email" => "system@dealog.de",
      "position" => "",
      "administrative_area_id" => "000000000000",
      "organization" => "DEalog System"
    }
  end

  defp build_author(author) do
    %MessageChange.Author{
      id: author["id"],
      name: "#{author["first_name"]} #{author["last_name"]}",
      email: author["email"],
      position: author["position"]
    }
  end

  defp build_organization(author) do
    %MessageChange.Organization{
      name: author["organization"],
      administrative_area_id: author["administrative_area_id"]
    }
  end
end
