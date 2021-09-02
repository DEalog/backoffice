defmodule DealogBackoffice.Messages.Projectors.DeletedMessage do
  use Commanded.Projections.Ecto,
    application: DealogBackoffice.App,
    name: "Messages.Projectors.DeletedMessage",
    consistency: :strong

  alias DealogBackoffice.Messages.Events.MessageDeleted

  alias DealogBackoffice.Messages.Projections.DeletedMessage

  project(%MessageDeleted{} = deleted, metadata, fn multi ->
    Ecto.Multi.insert(
      multi,
      :deleted_message,
      %DeletedMessage{
        id: deleted.message_id,
        title: deleted.title,
        body: deleted.body,
        category: deleted.category,
        ars: get_in(metadata, ["organization", "administrative_area_id"]) || "000000000000",
        organization: get_in(metadata, ["organization", "name"]) || "DEalog System",
        status: deleted.status,
        inserted_at: metadata.created_at
      }
    )
  end)
end
