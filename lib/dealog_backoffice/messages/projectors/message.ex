defmodule DealogBackoffice.Messages.Projectors.Message do
  use Commanded.Projections.Ecto,
    application: DealogBackoffice.App,
    name: "Messages.Projectors.Message",
    consistency: :strong

  alias DealogBackoffice.Messages.Events.MessageCreated

  alias DealogBackoffice.Messages.Projections.Message

  project(%MessageCreated{} = created, fn multi ->
    Ecto.Multi.insert(multi, :message, %Message{
      id: created.message_id,
      title: created.title,
      body: created.body
    })
  end)
end
