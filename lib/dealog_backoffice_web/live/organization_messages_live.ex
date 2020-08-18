defmodule DealogBackofficeWeb.OrganizationMessagesLive do
  use DealogBackofficeWeb, :live_view

  alias DealogBackoffice.Messages

  @impl true
  def mount(_params, _session, socket) do
    {messages, _total_count} = Messages.list_messages()

    socket =
      assign(socket,
        page_title: gettext("My organization"),
        active_page: :organization_messages,
        messages: messages
      )

    {:ok, socket}
  end
end
