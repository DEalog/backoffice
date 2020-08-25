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
    if has_changed?(message, attrs) do
      apply_change(message, attrs)
    else
      {:ok, message}
    end
  end

  # Run the actual command to change a message.
  defp apply_change(message, attrs) do
    change_message =
      attrs
      |> ChangeMessage.new()
      |> ChangeMessage.assign_message_id(message)

    with :ok <- App.dispatch(change_message, consistency: :strong) do
      get(message.id)
    end
  end

  @allowed_keys [:title, :body]

  # Check if there has been a content change.
  defp has_changed?(message, attrs) do
    attrs =
      attrs
      |> filter_by_map_keys(@allowed_keys)
      |> convert_map_keys()

    diff =
      message
      |> Map.from_struct()
      |> Map.take(Map.keys(attrs))
      |> MapDiff.diff(attrs)

    case diff do
      %{changed: :equal} -> false
      _ -> true
    end
  end

  # Filter the input data map to only allow valid entries.
  defp filter_by_map_keys(map, keys) do
    Map.take(map, keys ++ Enum.map(keys, &Atom.to_string/1))
  end

  # Convert the map keys to atoms (if not already) to enable comparision with the struct.
  defp convert_map_keys(map) do
    for {key, val} <- map, into: %{} do
      case key do
        key when is_binary(key) -> {String.to_atom(key), val}
        _ -> {key, val}
      end
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
