defmodule DealogBackofficeWeb.NewMessageLive do
  use DealogBackofficeWeb, :live_view

  alias DealogBackoffice.Messages

  @impl true
  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        title: gettext("New message"),
        active_page: :new_message,
        message: %{"title" => "", "body" => ""}
      )

    {:ok, socket}
  end

  @impl true
  def handle_event("create_message", %{"message" => new_message}, socket) do
    socket =
      case Messages.create_message(new_message) do
        {:error, {:validation_failure, errors}} ->
          assign(socket, error: true, errors: errors, message: new_message)

        {:ok, message} ->
          socket
          |> put_flash(
            :save_success,
            gettext("Message %{title} created successfully", title: message.title)
          )
          |> push_redirect(to: Routes.organization_messages_path(socket, :index))
      end

    {:noreply, socket}
  end
end
