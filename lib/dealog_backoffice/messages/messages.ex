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

  Returns the message when successful {:ok, message}
  Returns an error when invalid {:error, :not_found}
  """
  def create_message(attrs \\ %{}) do
    uuid = UUID.uuid4()

    create_message =
      attrs
      |> CreateMessage.new()
      |> CreateMessage.assign_uuid(uuid)

    with :ok <- App.dispatch(create_message, consistency: :strong) do
      get(uuid)
    end
  end

  def list_messages do
    ListMessages.paginate(Repo)
  end

  defp get(uuid) do
    case Repo.get(Message, uuid) do
      nil -> {:error, :not_found}
      message -> {:ok, message}
    end
  end
end
