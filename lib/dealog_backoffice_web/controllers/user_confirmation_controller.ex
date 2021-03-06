defmodule DealogBackofficeWeb.UserConfirmationController do
  use DealogBackofficeWeb, :controller

  alias DealogBackoffice.Accounts

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"user" => %{"email" => email}}) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_confirmation_instructions(
        user,
        &Routes.user_confirmation_url(conn, :confirm, &1)
      )
    end

    # Regardless of the outcome, show an impartial success/error message.
    conn
    |> put_flash(
      :info,
      gettext(
        "If the provided email address is in the system and it has not been confirmed yet, you will receive an email with instructions shortly."
      )
    )
    |> redirect(to: Routes.user_session_path(conn, :new))
  end

  # Do not log in the user after confirmation to avoid a
  # leaked token giving the user access to the account.
  def confirm(conn, %{"token" => token}) do
    case Accounts.confirm_user(token) do
      {:ok, _} ->
        conn
        |> put_flash(:info, gettext("Account confirmed successfully."))
        |> redirect(to: Routes.user_session_path(conn, :new))

      :error ->
        conn
        |> put_flash(:error, gettext("Confirmation link is invalid or it has expired."))
        |> redirect(to: Routes.user_session_path(conn, :new))
    end
  end
end
