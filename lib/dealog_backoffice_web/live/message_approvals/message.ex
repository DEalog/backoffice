defmodule DealogBackofficeWeb.MessageApprovalsLive.Message do
  @moduledoc """
  LiveView for message handling with message approvals.
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

  defp apply_action(socket, :approve, %{"id" => id}) do
    {:ok, message} = Messages.get_message(id)

    case Messages.approve_message(message) do
      {:ok, _} ->
        socket
        |> put_flash(
          :save_success,
          gettext("Message %{title} successfully approved", title: message.title)
        )
        |> push_redirect(to: Routes.approvals_path(socket, :index))
    end
  end

  defp apply_action(socket, :reject, %{"id" => id}) do
    {:ok, message} = Messages.get_message(id)

    case Messages.reject_message(message) do
      {:ok, message} ->
        socket
        |> put_flash(
          :save_success,
          gettext("Message %{title} successfully rejected", title: message.title)
        )
        |> push_redirect(to: Routes.approvals_path(socket, :index))
    end
  end
end
