defmodule DealogBackoffice.Messages do
  @moduledoc """
  The boundary for messages.
  """

  alias DealogBackoffice.Messages.Commands.{
    CreateMessage,
    ChangeMessage,
    SendMessageForApproval,
    DeleteMessage,
    ApproveMessage,
    RejectMessage,
    PublishMessage,
    ArchiveMessage,
    DiscardChange
  }

  alias DealogBackoffice.Messages.Projections.{
    Message,
    MessageForApproval,
    DeletedMessage,
    PublishedMessage,
    ArchivedMessage
  }

  alias DealogBackoffice.Messages.Queries.{
    ListMessages,
    ListMessageApprovals,
    ListPublishedMessages
  }

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

    with :ok <- App.dispatch(send_message, consistency: :strong) do
      get(Message, message.id)
    else
      _ ->
        {:error, :invalid_transition}
    end
  end

  @doc """
  Delete a message by its ID.

  This will change the status of the message to `deleted`.

  Returns {:ok, %DeleteMessage{}} when successfull
  Returns {:error, :invalid_transition} when not allowed
  """
  def delete_message(message_id) do
    case get_message(message_id) do
      {:ok, message} ->
        do_delete_message(message)

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  """
  def archive_message(message_id) do
    case get_message(message_id) do
      {:ok, message} ->
        do_archive_message(message)

      {:error, reason} ->
        {:error, reason}
    end
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

  @doc """
  Get a message sent for approval by its ID.
  """
  def get_message_for_approval(message_id), do: get(MessageForApproval, message_id)

  @doc """
  Approve a message.

  In addition to the implicit change of `status` an optional `note` can be
  passed. The new status is `approved`.

  This action can only be performed if the message is in status
  `waiting_for_approval`.

  Returns the message as {:ok, %MessageForApproval{}} when transitioned.
  Returns {:error, :invalid_transition} when transition is not allowed.
  """
  def approve_message(%MessageForApproval{} = message, note \\ "") do
    approve_message =
      message
      |> ApproveMessage.new()
      |> ApproveMessage.assign_message_id(message)
      |> ApproveMessage.set_status()
      |> ApproveMessage.maybe_set_note(note)

    with :ok <- App.dispatch(approve_message, consistency: :strong) do
      get(MessageForApproval, message.id)
    else
      _ ->
        {:error, :invalid_transition}
    end
  end

  @doc """
  Reject a message.

  In addition to the implicit change of `status` an optional `reason` can be
  passed. The new status is `rejected`.

  This action can only be performed if the message is in status
  `waiting_for_approval`.

  Returns the message as {:ok, %MessageForApproval{}} when transitioned.
  Returns {:error, :invalid_transition} when transition is not allowed.
  """
  def reject_message(%MessageForApproval{} = message, reason \\ "") do
    reject_message =
      message
      |> RejectMessage.new()
      |> RejectMessage.assign_message_id(message)
      |> RejectMessage.set_status()
      |> RejectMessage.maybe_set_reason(reason)

    with :ok <- App.dispatch(reject_message, consistency: :strong) do
      get(Message, message.id)
    else
      _ ->
        {:error, :invalid_transition}
    end
  end

  @doc """
  Get a (paginated) list of published messages.
  """
  def list_published_messages do
    ListPublishedMessages.paginate(Repo)
  end

  @doc """
  Publish a message.

  This action can only be applied when the message is in status `approved`.

  Returns the published message as {:ok, %PublishedMessage{}} when successful.
  Returns {:error, :invalid_transition} when transition is not allowed.
  """
  def publish_message(%MessageForApproval{} = message) do
    publish_message =
      message
      |> PublishMessage.new()
      |> PublishMessage.assign_message_id(message)
      |> PublishMessage.set_status()

    with :ok <- App.dispatch(publish_message, consistency: :strong) do
      get(PublishedMessage, message.id)
    else
      _ ->
        {:error, :invalid_transition}
    end
  end

  def discard_change(message_id) do
    {:ok, published_message} = get_published_message(message_id)
    {:ok, current_message} = get_message(message_id)

    discard_change =
      %{}
      |> DiscardChange.new()
      |> DiscardChange.assign_message_id(current_message)
      |> DiscardChange.apply_data_from(published_message)

    with :ok <- App.dispatch(discard_change, consistency: :strong) do
      get(Message, current_message.id)
    end
  end

  @doc """
  Get a published messsage by its ID.
  """
  def get_published_message(id) do
    get(PublishedMessage, id)
  end

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

  defp do_delete_message(message) do
    delete_message =
      message
      |> DeleteMessage.new()
      |> DeleteMessage.assign_message_id(message)
      |> DeleteMessage.set_status()

    with :ok <- App.dispatch(delete_message, consistency: :strong) do
      get(DeletedMessage, message.id)
    else
      _ ->
        {:error, :invalid_transition}
    end
  end

  defp do_archive_message(message) do
    archive_message =
      message
      |> ArchiveMessage.new()
      |> ArchiveMessage.assign_message_id(message)
      |> ArchiveMessage.set_status()

    with :ok <- App.dispatch(archive_message, consistency: :strong) do
      get(ArchivedMessage, message.id)
    end
  end
end
