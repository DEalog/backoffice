defmodule DealogBackoffice.Messages do
  @moduledoc """
  The boundary for messages.
  """

  alias DealogBackoffice.Messages.Commands.{CreateMessage, ChangeMessage, SendMessageForApproval}
  alias DealogBackoffice.Messages.Projections.{Message, MessageForApproval}
  alias DealogBackoffice.Messages.Queries.{ListMessages, ListMessageApprovals}
  alias DealogBackoffice.{App, Repo}

  @doc """
  Create a new message.

  The payload should contain the title and the body. The initial state is
  always `draft`.

  Returns the message when successful {:ok, message}
  Returns an error when invalid or failed {:error, reason}
  """
  def create_message(attrs \\ %{}) do
    message_id = UUID.uuid4()

    create_message =
      attrs
      |> CreateMessage.new()
      |> CreateMessage.assign_message_id(message_id)

    with :ok <- App.dispatch(create_message, consistency: :strong) do
      get(Message, message_id)
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

  @doc """
  Send a message for approval.

  The status will change to `waiting_for_approval`.

  Returns the message when successful {:ok, message}
  Returns an error tuple when invalid {:error, reason}
  """
  def send_message_for_approval(%Message{} = message) do
    send_message =
      message
      |> SendMessageForApproval.new()
      |> SendMessageForApproval.assign_message_id(message)
      |> SendMessageForApproval.set_status()

    with "draft" <- message.status,
         :ok <- App.dispatch(send_message, consistency: :strong) do
      get(Message, message.id)
    else
      _ ->
        {:error, :invalid_transition}
    end
  end

  @doc """
  TODO
  """
  def approve_message(%Message{} = message) do
    {:ok, message}
  end

  def reject_message(%Message{} = message) do
    {:ok, message}
  end

  @doc """
  Get a (paginated) list of messages.
  """
  def list_messages do
    ListMessages.paginate(Repo)
  end

  @doc """
  Get a message by its ID.
  """
  def get_message(message_id), do: get(Message, message_id)

  @doc """
  Get a (paginated) list of message approvals.
  """
  def list_message_approvals do
    ListMessageApprovals.paginate(Repo)
  end

  def get_message_for_approval(message_id), do: get(MessageForApproval, message_id)

  defp get(schema, uuid) do
    case Repo.get(schema, uuid) do
      nil -> {:error, :not_found}
      message -> {:ok, message}
    end
  end

  # Run the actual command to change a message.
  defp apply_change(message, attrs) do
    change_message =
      attrs
      |> ChangeMessage.new()
      |> ChangeMessage.assign_message_id(message)

    with :ok <- App.dispatch(change_message, consistency: :strong) do
      get(Message, message.id)
    end
  end

  @allowed_keys [:title, :body]

  # Check if there has been a content change.
  defp has_changed?(message, attrs) do
    attrs =
      attrs
      |> filter_by_map_keys(@allowed_keys)
      |> convert_map_keys()

    message
    |> Map.from_struct()
    |> Map.take(Map.keys(attrs))
    |> MapDiff.diff(attrs)
    |> case do
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
end
