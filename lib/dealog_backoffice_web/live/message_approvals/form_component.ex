defmodule DealogBackofficeWeb.MessageApprovalsLive.FormComponent do
  use DealogBackofficeWeb, :live_component

  alias DealogBackoffice.Messages

  @impl true
  def update(%{message: message, reason: reason} = assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign(message: message)
      |> assign(reason: reason)

    {:ok, socket}
  end

  @impl true
  def handle_event("save_reason", %{"message" => message_params}, socket) do
    {:noreply, save_message(socket, socket.assigns.action, message_params)}
  end

  defp save_message(socket, :reject, %{"id" => id, "reason" => reason}) do
    {:ok, message} = Messages.get_message_for_approval(id)

    case Messages.reject_message(message, reason) do
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
