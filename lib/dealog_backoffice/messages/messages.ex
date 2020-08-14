defmodule DealogBackoffice.Messages do
  @moduledoc """
  The boundary for messages.
  """

  alias DealogBackoffice.Messages.Commands.{CreateMessage, ChangeMessage}
  alias DealogBackoffice.Messages.Projections.Message
  alias DealogBackoffice.Messages.Queries.ListMessages
  alias DealogBackoffice.{App, Repo}

  @doc """
  Create a new message.

  The payload should contain the title and the body. The initial state is 
  always `draft`.

  Returns the message when successful {:ok, message}
  Returns an error when invalid or failed {:error, reason}
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

  @doc """
  Change an existing message.

  The status of the message is reset to `draft` again.

  Returns the message when successful {:ok, message}
  Returns an error tuple when invalid {:error, reason}
  """
  def change_message(%Message{} = message, attrs \\ %{}) do
    change_message =
      attrs
      |> ChangeMessage.new()
      |> ChangeMessage.assign_message_id(message)

    with :ok <- App.dispatch(change_message, consistency: :strong) do
      get(message.id)
    end
  end

  def list_messages do
    ListMessages.paginate(Repo)
  end

  def get_message(message_id), do: get(message_id)

  defp get(uuid) do
    case Repo.get(Message, uuid) do
      nil -> {:error, :not_found}
      message -> {:ok, message}
    end
  end
end
