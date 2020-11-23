defmodule DealogBackofficeWeb.OrganizationMessagesLive.Edit do
  use DealogBackofficeWeb, :live_view

  alias DealogBackoffice.Messages

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign_defaults(socket, session)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    assign(socket,
      page_title: gettext("Create new message"),
      title: gettext("New message"),
      active_page: :organization_messages,
      message: %{id: nil, title: nil, body: nil}
    )
  end

  defp apply_action(socket, :change, %{"id" => id}) do
    case Messages.get_message(id) do
      {:ok, %{status: "waiting_for_approval"} = message} ->
        socket
        |> put_flash(
          :save_error,
          gettext("Message %{title} is in review an cannot be changed",
            title: message.title
          )
        )
        |> push_redirect(to: Routes.organization_messages_path(socket, :show, message.id))

      {:ok, message} ->
        assign(socket,
          page_title: gettext("Edit message %{title}", title: message.title),
          title: gettext("Change message"),
          active_page: :organization_messages,
          message: message
        )
    end
  end

  defp apply_action(socket, :send_for_approval, %{"id" => id}) do
    # TODO Move to change_message function to keep API clean
    {:ok, original_message} = Messages.get_message(id)

    case Messages.send_message_for_approval(original_message) do
      {:error, :invalid_transition} ->
        socket
        |> put_flash(
          :save_error,
          gettext("Message %{title} has to be in status draft in order to send for approval",
            title: original_message.title
          )
        )
        |> push_redirect(
          to: Routes.organization_messages_path(socket, :show, original_message.id)
        )

      {:ok, message} ->
        socket
        |> put_flash(
          :save_success,
          gettext("Message %{title} successfully sent for approval", title: message.title)
        )
        |> push_redirect(to: Routes.organization_messages_path(socket, :show, message.id))
    end
  end

  defp apply_action(socket, :delete, %{"id" => id}) do
    case Messages.delete_message(id) do
      {:error, :invalid_transition} ->
        socket
        |> put_flash(
          :save_error,
          gettext("Message %{id} could not be deleted",
            id: id
          )
        )
        |> push_redirect(to: Routes.organization_messages_path(socket, :show, id))

      {:error, :not_found} ->
        socket
        |> put_flash(
          :save_error,
          gettext("Message %{id} could not be found",
            id: id
          )
        )
        |> push_redirect(to: Routes.organization_messages_path(socket, :show, id))

      {:ok, message} ->
        socket
        |> put_flash(
          :save_success,
          gettext("Message %{title} successfully deleted", title: message.title)
        )
        |> push_redirect(to: Routes.organization_messages_path(socket, :index))
    end
  end

  defp apply_action(socket, :archive, %{"id" => id}) do
    case Messages.archive_message(id) do
      {:error, :invalid_transition} ->
        socket
        |> put_flash(
          :save_error,
          gettext("Message %{id} could not be archived",
            id: id
          )
        )
        |> push_redirect(to: Routes.organization_messages_path(socket, :show, id))

      {:error, :not_found} ->
        socket
        |> put_flash(
          :save_error,
          gettext("Message %{id} could not be found",
            id: id
          )
        )
        |> push_redirect(to: Routes.organization_messages_path(socket, :show, id))

      {:ok, message} ->
        socket
        |> put_flash(
          :save_success,
          gettext("Message %{title} successfully archived", title: message.title)
        )
        |> push_redirect(to: Routes.organization_messages_path(socket, :index))
    end
  end
end
