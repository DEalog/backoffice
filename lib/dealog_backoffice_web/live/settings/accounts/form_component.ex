defmodule DealogBackofficeWeb.SettingsLive.Accounts.FormComponent do
  use DealogBackofficeWeb, :live_component

  alias DealogBackoffice.Accounts
  alias DealogBackoffice.Accounts.Projections.Account
  alias DealogBackofficeWeb.SettingsLive.Accounts.FormData

  @impl true
  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)

    {:ok, socket}
  end

  @impl true
  def handle_event("save", %{"form_data" => account_params}, socket) do
    {:noreply, apply_action(socket, socket.assigns.action, account_params)}
  end

  defp apply_action(socket, :new, account_params) do
    changeset =
      build_changeset(%Account{}, account_params)
      |> IO.inspect()

    case Accounts.create_account_from_changeset(changeset) do
      {:error, changeset} ->
        assign(socket, changeset: changeset)

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
    account = load_account(account_params)
    changeset = build_changeset(account, account_params)

    case Accounts.change_account_from_changeset(account, changeset) do
      {:error, changeset} ->
        assign(socket, changeset: changeset)

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

  defp build_changeset(%Account{} = account, params) do
    account
    |> FormData.load_from_account()
    |> FormData.changeset_for_account(params)
    |> Map.put(:action, :change_account)
  end

  defp load_account(%{"id" => id}) do
    {:ok, account} = Accounts.get_account(id)

    account
  end
end
