defmodule DealogBackofficeWeb.OrganizationMessagesLive.Edit do
  use DealogBackofficeWeb, :live_view

  alias DealogBackoffice.Messages

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    assign(socket,
      title: gettext("New message"),
      active_page: :new_message,
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
          title: gettext("Change message"),
          active_page: :change_message,
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
        |> push_redirect(to: Routes.organization_messages_path(socket, :index))
    end
  end
end
