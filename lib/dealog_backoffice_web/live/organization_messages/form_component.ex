defmodule DealogBackofficeWeb.OrganizationMessagesLive.FormComponent do
  use DealogBackofficeWeb, :live_component

  alias DealogBackoffice.Messages

  @impl true
  def update(%{message: message} = assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign(message: message)

    {:ok, socket}
  end

  @impl true
  def handle_event("save_message", %{"message" => message_params}, socket) do
    {:noreply, apply_action(socket, socket.assigns.action, message_params)}
  end

  defp apply_action(socket, :new, message_params) do
    message_params = put_user_attrs(message_params, socket.assigns.current_user)

    case Messages.create_message(message_params) do
      {:error, {:validation_failure, errors}} ->
        assign(socket, error: true, errors: errors, message: convert(message_params))

      {:ok, message} ->
        socket
        |> put_flash(
          :save_success,
          gettext("Message %{title} created successfully", title: message.title)
        )
        |> push_redirect(to: socket.assigns.return_to <> message.id)
    end
  end

  defp apply_action(socket, :change, message_params) do
    # TODO Move to change_message function to keep API clean
    {:ok, original_message} =
      message_params
      |> Map.get("id")
      |> Messages.get_message()

    case Messages.change_message(original_message, message_params) do
      {:error, {:validation_failure, errors}} ->
        assign(socket, error: true, errors: errors, message: convert(message_params))

      {:ok, message} ->
        socket
        |> put_flash(
          :save_success,
          gettext("Message %{title} changed successfully", title: message.title)
        )
        |> push_redirect(to: socket.assigns.return_to)
    end
  end

  defp convert(%{"id" => id, "title" => title, "body" => body}),
    do: %{id: id, title: title, body: body}

  defp put_user_attrs(message_params, user),
    do: Map.merge(message_params, extract_user_attrs(user))

  defp extract_user_attrs(user) do
    %{
      author_id: user.id,
      author_email: user.email,
      author_first_name: user.account.first_name,
      author_last_name: user.account.last_name,
      administrative_area_id: user.account.administrative_area_id,
      organization: user.account.organization,
      position: user.account.position
    }
  end
end
