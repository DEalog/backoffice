defmodule DealogBackofficeWeb.UserSettingsController do
  use DealogBackofficeWeb, :controller

  alias DealogBackoffice.Accounts

  def confirm_email(conn, %{"token" => token}) do
    case Accounts.update_user_email(conn.assigns.current_user, token) do
      :ok ->
        conn
        |> put_flash(:info, gettext("Email changed successfully."))
        |> redirect(to: Routes.user_session_path(conn, :new))

      :error ->
        conn
        |> put_flash(:error, gettext("Email change link is invalid or it has expired."))
        |> redirect(to: Routes.user_session_path(conn, :new))
    end
  end
end
