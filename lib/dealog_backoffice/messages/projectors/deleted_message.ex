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
        status: deleted.status,
        inserted_at: metadata.created_at
      }
    )
  end)
end
