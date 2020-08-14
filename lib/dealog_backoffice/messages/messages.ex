defmodule DealogBackoffice.Messages do
  @moduledoc """
  The boundary for messages.
  """

  alias DealogBackoffice.Messages.Commands.CreateMessage
  alias DealogBackoffice.Messages.Projections.Message
  alias DealogBackoffice.{App, Repo}
  alias DealogBackoffice.Messages.Queries.ListMessages

  @doc """
  Create a new message.

  The payload should contain the title and the body.

  Returns the message when successful
  Returns an error when invalid
  """
  def create_message(attrs \\ %{}) do
    uuid = UUID.uuid4()

    create_message =
      attrs
      |> CreateMessage.new()
      |> CreateMessage.assign_uuid(uuid)

    with :ok <- App.dispatch(create_message, consistency: :strong) do
      get(Message, uuid)
    end
  end

  def list_messages do
    ListMessages.paginate(Repo)
  end

  defp get(schema, uuid) do
    case Repo.get(schema, uuid) do
      nil -> {:error, :not_found}
      projection -> {:ok, projection}
    end
  end
end
