defmodule DealogBackofficeWeb.OrganizationMessagesLive.FormComponent do
  use DealogBackofficeWeb, :live_component

  alias DealogBackoffice.Messages

  @impl true
  def update(%{message: message} = assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign(message: message)
      |> assign_available_categories()

    {:ok, socket}
  end

  @impl true
  def handle_event("save_message", %{"message" => message_params}, socket) do
    {:noreply, apply_action(socket, socket.assigns.action, message_params)}
  end

  defp apply_action(socket, :new, message_params) do
    user = socket.assigns.current_user

    case Messages.create_message(user, message_params) do
      {:error, {:validation_failure, errors}} ->
        assign(socket, error: true, errors: errors, message: convert(message_params))

      {:ok, message} ->
        socket
        |> put_flash(
          :save_success,
          gettext("Message %{title} created successfully", title: message.title)
        )
        |> push_redirect(to: socket.assigns.return_to <> message.id)
    end
  end

  defp apply_action(socket, :change, message_params) do
    user = socket.assigns.current_user

    {:ok, original_message} =
      message_params
      |> Map.get("id")
      |> Messages.get_message()

    case Messages.change_message(user, original_message, message_params) do
      {:error, {:validation_failure, errors}} ->
        assign(socket, error: true, errors: errors, message: convert(message_params))

      {:ok, message} ->
        socket
        |> put_flash(
          :save_success,
          gettext("Message %{title} changed successfully", title: message.title)
        )
        |> push_redirect(to: socket.assigns.return_to)
    end
  end

  defp assign_available_categories(socket) do
    assign(socket,
      available_categories: [
        {gettext("Other events"), "Other"},
        {gettext("Geophysical (inc. landslide)"), "Geo"},
        {gettext("Meteorological (inc. flood)"), "Met"},
        {gettext("General emergency and public safety"), "Safety"},
        {gettext("Law enforcement, military, homeland and local/private security"), "Security"},
        {gettext("Rescue and recovery"), "Rescue"},
        {gettext("Fire suppression and rescue"), "Fire"},
        {gettext("Medical and public health"), "Health"},
        {gettext("Pollution and other environmental"), "Env"},
        {gettext("Public and private transportation"), "Transport"},
        {gettext("Utility, telecommunication, other non-transport infrastructure"), "Infra"},
        {
          gettext(
            "Chemical, Biological, Radiological, Nuclear or High-Yield Explosive threat or attack"
          ),
          "CBRNE"
        }
      ]
    )
  end

  defp convert(%{"id" => id, "title" => title, "body" => body, "category" => category}),
    do: %{id: id, title: title, body: body, category: category}
end
