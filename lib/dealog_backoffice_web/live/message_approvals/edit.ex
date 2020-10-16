defmodule DealogBackofficeWeb.MessageApprovalsLive.Edit do
  @moduledoc """
  LiveView for message handling with message approvals or rejections.
  """

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

  defp apply_action(socket, :approve, %{"id" => id}) do
    case Messages.get_message_for_approval(id) do
      {:ok, message} ->
        assign(socket,
          page_title: gettext("Approve message %{title}", title: message.title),
          title: gettext("Approve message"),
          active_page: :approvals,
          message: message,
          note: nil
        )
    end
  end

  defp apply_action(socket, :reject, %{"id" => id}) do
    case Messages.get_message_for_approval(id) do
      {:ok, message} ->
        assign(socket,
          page_title: gettext("Reject message %{title}", title: message.title),
          title: gettext("Reject message"),
          active_page: :approvals,
          message: message,
          reason: nil
        )
    end
  end

  defp apply_action(socket, :publish, %{"id" => id}) do
    case Messages.get_message_for_approval(id) do
      {:ok, message} ->
        publish_message(socket, message)

      {:error, _} ->
        socket
        |> put_flash(
          :not_found_error,
          gettext("Message %{id} could not be found",
            id: id
          )
        )
        |> push_redirect(to: Routes.approvals_path(socket, :index))
    end
  end

  defp publish_message(socket, message) do
    case Messages.publish_message(message) do
      {:error, :invalid_transition} ->
        socket
        |> put_flash(
          :save_error,
          gettext("Message %{title} has to be in status approved in order to be published",
            title: message.title
          )
        )
        |> push_redirect(to: Routes.approvals_path(socket, :show, message.id))

      {:ok, message} ->
        socket
        |> put_flash(
          :save_success,
          gettext("Message %{title} successfully published", title: message.title)
        )
        |> push_redirect(to: Routes.approvals_path(socket, :index))
    end
  end
end
