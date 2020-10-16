defmodule DealogBackofficeWeb.AllMessagesLive.Index do
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

  defp apply_action(socket, :index, _params) do
    {messages, _total_count} = Messages.list_published_messages()

    assign(socket,
      page_title: gettext("All messages"),
      active_page: :all_messages,
      messages: messages
    )
  end
end
