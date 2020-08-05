defmodule DealogBackoffice.Messages do
  @moduledoc """
  The boundary for messages.
  """

  alias DealogBackoffice.Messages.Commands.CreateMessage
  alias DealogBackoffice.App

  def create_message(attrs \\ %{}) do
    uuid = Ecto.UUID.generate()

    create_message =
      attrs
      |> CreateMessage.new()
      |> CreateMessage.assign_uuid(uuid)

    App.dispatch(create_message)
  end
end
