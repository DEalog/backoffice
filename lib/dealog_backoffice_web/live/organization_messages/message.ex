defmodule DealogBackofficeWeb.OrganizationMessagesLive.Message do
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
    {:ok, message} = Messages.get_message(id)

    assign(socket,
      title: gettext("Change message"),
      active_page: :change_message,
      message: message
    )
  end
end
