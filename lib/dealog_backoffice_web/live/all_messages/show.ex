defmodule DealogBackofficeWeb.AllMessagesLive.Show do
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

  defp apply_action(socket, :show, %{"id" => id}) do
    case Messages.get_published_message(id) do
      {:ok, message} ->
        assign(socket,
          title: message.title,
          active_page: :all_messages,
          message: message
        )

      {:error, :not_found} ->
        socket
        |> put_flash(
          :not_found_error,
          gettext("Message %{id} could not be found",
            id: id
          )
        )
        |> push_redirect(to: Routes.all_messages_path(socket, :index))
    end
  end

  def parse(content) do
    Phoenix.HTML.Format.text_to_html(content)
  end
end
