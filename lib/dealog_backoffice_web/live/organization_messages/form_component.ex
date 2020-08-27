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
    {:noreply, save_message(socket, socket.assigns.action, message_params)}
  end

  defp save_message(socket, :change, message_params) do
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

  defp save_message(socket, :new, message_params) do
    case Messages.create_message(message_params) do
      {:error, {:validation_failure, errors}} ->
        assign(socket, error: true, errors: errors, message: convert(message_params))

      {:ok, message} ->
        socket
        |> put_flash(
          :save_success,
          gettext("Message %{title} created successfully", title: message.title)
        )
        |> push_redirect(to: socket.assigns.return_to)
    end
  end

  defp convert(%{"id" => id, "title" => title, "body" => body}),
    do: %{id: id, title: title, body: body}
end
