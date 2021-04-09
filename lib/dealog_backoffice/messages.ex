defmodule DealogBackoffice.Messages do
  @moduledoc """
  The boundary for messages.
  """

  import Ecto.Query

  alias DealogBackoffice.Accounts.User
  alias DealogBackoffice.Messages.{Author, Organization}

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
    ArchivedMessage,
    MessageChange
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
  def create_message(%User{} = user, attrs \\ %{}) do
    message_id = UUID.uuid4()

    create_message =
      attrs
      |> CreateMessage.new()
      |> CreateMessage.assign_message_id(message_id)

    author = build_author(user)
    organization = build_organization(user)

    with :ok <-
           App.dispatch(create_message,
             consistency: :strong,
             metadata: %{"author" => author, "organization" => organization}
           ) do
      get(Message, message_id)
    end
  end

  @doc """
  Change an existing message.

  The status of the message is reset to `draft` again.

  Returns the message when successful {:ok, message}
  Returns an error tuple when invalid {:error, reason}
  """
  def change_message(%User{} = user, %Message{} = message, attrs \\ %{}) do
    if has_changed?(message, attrs) do
      apply_change(user, message, attrs)
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
  def send_message_for_approval(%User{} = user, %Message{} = message) do
    send_message =
      message
      |> SendMessageForApproval.new()
      |> SendMessageForApproval.assign_message_id(message)
      |> SendMessageForApproval.set_status()

    author = build_author(user)
    organization = build_organization(user)

    with :ok <-
           App.dispatch(send_message,
             consistency: :strong,
             metadata: %{"author" => author, "organization" => organization}
           ) do
      get(Message, message.id)
    else
      _ ->
        {:error, :invalid_transition}
    end
  end

  @doc """
  Delete a message by its ID.

  This will change the status of the message to `deleted`.

  Returns {:ok, %DeletedMessage{}} when successfull
  Returns {:error, :invalid_transition} when not allowed
  """
  def delete_message(%User{} = user, message_id) do
    case get_message(message_id) do
      {:ok, message} ->
        do_delete_message(user, message)

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
  def get_message(message_id) do
    message =
      from(m in Message,
        where: m.id == ^message_id,
        preload: [changes: ^from(mc in MessageChange, order_by: :inserted_at)]
      )
      |> Repo.one()

    case message do
      nil -> {:error, :not_found}
      message -> {:ok, message}
    end
  end

  @doc """
  Get a (paginated) list of message approvals.
  """
  def list_message_approvals do
    ListMessageApprovals.paginate(Repo)
  end

  @doc """
  Get a message sent for approval by its ID.
  """
  def get_message_for_approval(message_id) do
    from(m in MessageForApproval,
      where: m.id == ^message_id,
      preload: [changes: ^from(mc in MessageChange, order_by: :inserted_at)]
    )
    |> Repo.one()
    |> case do
      nil -> {:error, :not_found}
      message -> {:ok, message}
    end
  end

  @doc """
  Approve a message.

  In addition to the implicit change of `status` an optional `note` can be
  passed. The new status is `approved`.

  This action can only be performed if the message is in status
  `waiting_for_approval`.

  Returns the message as {:ok, %MessageForApproval{}} when transitioned.
  Returns {:error, :invalid_transition} when transition is not allowed.
  """
  def approve_message(%User{} = user, %MessageForApproval{} = message, note \\ "") do
    approve_message =
      message
      |> ApproveMessage.new()
      |> ApproveMessage.assign_message_id(message)
      |> ApproveMessage.set_status()
      |> ApproveMessage.maybe_set_note(note)

    author = build_author(user)
    organization = build_organization(user)

    with :ok <-
           App.dispatch(approve_message,
             consistency: :strong,
             metadata: %{"author" => author, "organization" => organization}
           ) do
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
  def reject_message(%User{} = user, %MessageForApproval{} = message, reason \\ "") do
    reject_message =
      message
      |> RejectMessage.new()
      |> RejectMessage.assign_message_id(message)
      |> RejectMessage.set_status()
      |> RejectMessage.maybe_set_reason(reason)

    author = build_author(user)
    organization = build_organization(user)

    with :ok <-
           App.dispatch(reject_message,
             consistency: :strong,
             metadata: %{"author" => author, "organization" => organization}
           ) do
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
  def publish_message(%User{} = user, %MessageForApproval{} = message) do
    publish_message =
      message
      |> PublishMessage.new()
      |> PublishMessage.assign_message_id(message)
      |> PublishMessage.set_status()

    author = build_author(user)
    organization = build_organization(user)

    with :ok <-
           App.dispatch(publish_message,
             consistency: :strong,
             metadata: %{"author" => author, "organization" => organization}
           ) do
      get(PublishedMessage, message.id)
    else
      _ ->
        {:error, :invalid_transition}
    end
  end

  @doc """
  Archive a message by its ID.

  This will change the status of the message to `archived`.

  Returns {:ok, %ArchivedMessage{}} when successfull
  Returns {:error, :invalid_transition} when not allowed
  """
  def archive_message(%User{} = user, message_id) do
    case get_message(message_id) do
      {:ok, message} ->
        do_archive_message(user, message)

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Discard a change to the currently published message version.

  This will replace the `:title` and `:body` to the respective one of the
  published message.

  Returns {:ok, %Message{}} when successfull
  Returns {:error, :invalid_transition} when not allowed
  """
  def discard_change(%User{} = user, message_id) do
    {:ok, published_message} = get_published_message(message_id)
    {:ok, current_message} = get_message(message_id)

    discard_change =
      %{}
      |> DiscardChange.new()
      |> DiscardChange.assign_message_id(current_message)
      |> DiscardChange.apply_data_from(published_message)

    author = build_author(user)
    organization = build_organization(user)

    with :ok <-
           App.dispatch(discard_change,
             consistency: :strong,
             metadata: %{"author" => author, "organization" => organization}
           ) do
      get(Message, current_message.id)
    end
  end

  @doc """
  Discard a change to the currently published message version and directly
  archive the message.

  This will replace the `:title` and `:body` to the respective one of the
  published message and archive this version.

  Returns {:ok, %ArchivedMessage{}} when successfull
  Returns {:error, :invalid_transition} when not allowed
  """
  def discard_change_and_archive(%User{} = user, message_id) do
    with {:ok, _} <- discard_change(user, message_id) do
      archive_message(user, message_id)
    end
  end

  @doc """
  Get a published messsage by its ID.
  """
  def get_published_message(id) do
    from(m in PublishedMessage,
      where: m.id == ^id,
      preload: [changes: ^from(mc in MessageChange, order_by: :inserted_at)]
    )
    |> Repo.one()
    |> case do
      nil -> {:error, :not_found}
      message -> {:ok, message}
    end
  end

  defp get(schema, uuid) do
    entity = Repo.get(schema, uuid)

    case entity do
      nil -> {:error, :not_found}
      message -> {:ok, message}
    end
  end

  # Build author from user to add to meta data
  defp build_author(%User{} = user) do
    %Author{
      id: user.id,
      first_name: user.account.first_name,
      last_name: user.account.last_name,
      email: user.email,
      position: user.account.position
    }
  end

  defp build_organization(%User{} = user) do
    %Organization{
      id: nil,
      name: user.account.organization,
      administrative_area_id: user.account.administrative_area_id
    }
  end

  # Run the actual command to change a message.
  defp apply_change(user, message, attrs) do
    change_message =
      attrs
      |> ChangeMessage.new()
      |> ChangeMessage.assign_message_id(message)

    author = build_author(user)
    organization = build_organization(user)

    with :ok <-
           App.dispatch(change_message,
             consistency: :strong,
             metadata: %{"author" => author, "organization" => organization}
           ) do
      get(Message, message.id)
    end
  end

  @allowed_keys [:title, :body, :category]

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

  defp do_delete_message(user, message) do
    delete_message =
      message
      |> DeleteMessage.new()
      |> DeleteMessage.assign_message_id(message)
      |> DeleteMessage.set_status()

    author = build_author(user)
    organization = build_organization(user)

    with :ok <-
           App.dispatch(delete_message,
             consistency: :strong,
             metadata: %{"author" => author, "organization" => organization}
           ) do
      get(DeletedMessage, message.id)
    else
      _ ->
        {:error, :invalid_transition}
    end
  end

  defp do_archive_message(user, message) do
    author = build_author(user)

    archive_message =
      message
      |> ArchiveMessage.new()
      |> ArchiveMessage.assign_message_id(message)
      |> ArchiveMessage.set_status()

    with :ok <-
           App.dispatch(archive_message, consistency: :strong, metadata: %{"author" => author}) do
      get(ArchivedMessage, message.id)
    end
  end
end
