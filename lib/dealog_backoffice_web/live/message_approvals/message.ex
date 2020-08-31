defmodule DealogBackofficeWeb.MessageApprovalsLive.Message do
  @moduledoc """
  LiveView for message handling with message approvals or rejections.
  """

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

  defp apply_action(socket, :reject, %{"id" => id}) do
    case Messages.get_message_for_approval(id) do
      {:ok, message} ->
        assign(socket,
          title: gettext("Reject message"),
          active_page: :approvals,
          message: message,
          reason: nil
        )
    end
  end
end
