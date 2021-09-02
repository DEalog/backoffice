defmodule DealogBackofficeWeb.MessageApprovalsLive.Index do
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
    current_account = get_account(socket.assigns.current_user.account)
    ars = get_administrative_area(current_account)
    {messages, _total_count} = Messages.list_message_approvals_for_administrative_area(ars)

    assign(socket,
      page_title: gettext("Approvals"),
      active_page: :approvals,
      messages: messages
    )
  end

  defp get_account(nil), do: nil
  defp get_account(account), do: account

  defp get_administrative_area(nil), do: nil
  defp get_administrative_area(%{administrative_area: %{ars: ars}}), do: ars
end
