defmodule DealogBackofficeWeb.ChangeMessageLive do
  use DealogBackofficeWeb, :live_view

  alias DealogBackoffice.Messages

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok, message} = Messages.get_message(id)

    socket =
      assign(socket,
        title: gettext("Change message"),
        active_page: :change_message,
        message: %{"id" => message.id, "title" => message.title, "body" => message.body}
      )

    {:ok, socket}
  end

  @impl true
  def handle_event("change_message", %{"message" => changed_message}, socket) do
    {:ok, original_message} =
      changed_message
      |> Map.get("id")
      |> Messages.get_message()

    socket =
      case Messages.change_message(original_message, changed_message) do
        {:error, {:validation_failure, errors}} ->
          assign(socket, error: true, errors: errors, message: changed_message)

        {:ok, message} ->
          socket
          |> put_flash(
            :save_success,
            gettext("Message %{title} changed successfully", title: message.title)
          )
          |> push_redirect(to: Routes.organization_messages_path(socket, :index))
      end

    {:noreply, socket}
  end
end
