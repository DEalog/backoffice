defmodule DealogBackofficeWeb.SettingsLive.Accounts.FormComponent do
  use DealogBackofficeWeb, :live_component

  alias DealogBackoffice.Accounts

  @impl true
  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)

    {:ok, socket}
  end

  @impl true
  def handle_event("save_account", %{"account" => account_params}, socket) do
    {:noreply, apply_action(socket, socket.assigns.action, account_params)}
  end

  defp apply_action(socket, :new, account_params) do
    case Accounts.create_account(account_params) do
      {:error, {:validation_failure, errors}} ->
        assign(socket, error: true, errors: errors, account: convert(account_params))

      {:ok, account} ->
        socket
        |> put_flash(
          :save_success,
          gettext("Account for %{first_name} %{last_name} created successfully",
            first_name: account.first_name,
            last_name: account.last_name
          )
        )
        |> push_redirect(to: socket.assigns.return_to)
    end
  end

  defp apply_action(socket, :change, account_params) do
    # TODO Move to change_message function to keep API clean
    {:ok, original_account} =
      account_params
      |> Map.get("id")
      |> Accounts.get_account()

    case Accounts.change_account(original_account, account_params) do
      {:error, {:validation_failure, errors}} ->
        assign(socket, error: true, errors: errors, account: convert(account_params))

      {:ok, account} ->
        socket
        |> put_flash(
          :save_success,
          gettext("Account for %{first_name} %{last_name} updated successfully",
            first_name: account.first_name,
            last_name: account.last_name
          )
        )
        |> push_redirect(to: socket.assigns.return_to)
    end
  end

  defp convert(%{
         "id" => id,
         "user_id" => user_id,
         "first_name" => first_name,
         "last_name" => last_name
       }),
       do: %{id: id, user_id: user_id, first_name: first_name, last_name: last_name}
end
