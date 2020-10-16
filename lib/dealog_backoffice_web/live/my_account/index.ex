defmodule DealogBackofficeWeb.MyAccountLive.Index do
  use DealogBackofficeWeb, :live_view

  alias DealogBackoffice.Accounts

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign_defaults(socket, session)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def apply_action(socket, :index, _params) do
    user = socket.assigns.current_user

    assign(
      socket,
      page_title: gettext("My account"),
      active_page: :my_account,
      email_changeset: Accounts.change_user_email(user),
      password_changeset: Accounts.change_user_password(user)
    )
  end

  @impl true
  def handle_event(
        "update_email",
        %{"current_password" => password, "user" => user_params},
        socket
      ) do
    user = socket.assigns.current_user

    socket =
      case Accounts.apply_user_email(user, password, user_params) do
        {:ok, applied_user} ->
          Accounts.deliver_update_email_instructions(
            applied_user,
            user.email,
            &Routes.user_settings_url(socket, :confirm_email, &1)
          )

          socket
          |> put_flash(
            :save_success,
            gettext(
              "Email address was successfully changed. Please check your email account for a confirmation email and click the link."
            )
          )

        {:error, changeset} ->
          socket
          |> put_flash(
            :save_error,
            gettext("Check errors in the form fields below.")
          )
          |> assign(email_changeset: changeset)
      end

    {:noreply, socket}
  end

  @impl true
  def handle_event(
        "update_password",
        %{"current_password" => password, "user" => user_params},
        socket
      ) do
    user = socket.assigns.current_user

    case Accounts.update_user_password(user, password, user_params) do
      {:ok, user} ->
        socket =
          socket
          |> put_flash(:save_success, gettext("Password was successfully updated."))

        {:noreply,
         push_event(socket, "relogin", %{email: user.email, password: user_params["password"]})}

      {:error, changeset} ->
        socket =
          socket
          |> put_flash(
            :save_error,
            gettext("Check errors in the form fields below.")
          )
          |> assign(password_changeset: changeset)

        {:noreply, socket}
    end
  end
end
