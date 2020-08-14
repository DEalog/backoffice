defmodule DealogBackoffice.Messages.Projectors.Message do
  use Commanded.Projections.Ecto,
    application: DealogBackoffice.App,
    name: "Messages.Projectors.Message",
    consistency: :strong

  alias DealogBackoffice.Messages.Events.{MessageCreated, MessageChanged}

  alias DealogBackoffice.Messages.Projections.Message

  project(%MessageCreated{} = created, fn multi ->
    Ecto.Multi.insert(multi, :message, %Message{
      id: created.message_id,
      title: created.title,
      body: created.body,
      status: "draft"
    })
  end)

  project(%MessageChanged{} = changed, fn multi ->
    update_message(multi, changed.message_id,
      title: changed.title,
      body: changed.body,
      status: changed.status,
      updated_at: NaiveDateTime.utc_now()
    )
  end)

  defp update_message(multi, message_id, changes) do
    Ecto.Multi.update_all(multi, :message, query(message_id), set: changes)
  end

  defp query(message_id) do
    from(m in Message, where: m.id == ^message_id)
  end
end
