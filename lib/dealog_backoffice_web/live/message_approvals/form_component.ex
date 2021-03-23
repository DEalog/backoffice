defmodule DealogBackofficeWeb.MessageApprovalsLive.FormComponent do
  use DealogBackofficeWeb, :live_component

  alias DealogBackoffice.Messages

  @impl true
  def update(%{message: message, text: text} = assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign(message: message)
      |> assign(text: text)

    {:ok, socket}
  end

  @impl true
  def handle_event("save", %{"message" => message_params}, socket) do
    {:noreply, apply_action(socket, socket.assigns.action, message_params)}
  end

  defp apply_action(socket, :approve, %{"id" => id, "text" => note}) do
    user = socket.assigns.current_user
    {:ok, message} = Messages.get_message_for_approval(id)

    case Messages.approve_message(user, message, note) do
      {:ok, message} ->
        socket
        |> put_flash(
          :save_success,
          gettext("Message %{title} approved", title: message.title)
        )
        |> push_redirect(to: socket.assigns.return_to)
    end
  end

  defp apply_action(socket, :reject, %{"id" => id, "text" => reason}) do
    user = socket.assigns.current_user
    {:ok, message} = Messages.get_message_for_approval(id)

    case Messages.reject_message(user, message, reason) do
      {:ok, message} ->
        socket
        |> put_flash(
          :save_success,
          gettext("Message %{title} rejected", title: message.title)
        )
        |> push_redirect(to: socket.assigns.return_to)
    end
  end
end
