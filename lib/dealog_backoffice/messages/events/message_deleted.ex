defmodule DealogBackoffice.Messages.Events.MessageDeleted do
  @derive Jason.Encoder
  defstruct [
    :message_id,
    :title,
    :body,
    :category,
    :status
  ]

  defimpl Commanded.Event.Upcaster, for: __MODULE__ do
    alias DealogBackoffice.Messages.Events.MessageDeleted

    def upcast(%MessageDeleted{status: "deleted", category: nil} = event, _metadata) do
      %MessageDeleted{event | status: :deleted, category: "Other"}
    end

    def upcast(%MessageDeleted{status: "deleted"} = event, _metadata) do
      %MessageDeleted{event | status: :deleted}
    end
  end
end
