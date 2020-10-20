defmodule DealogBackofficeWeb.UserApiController do
  @moduledoc """
  The controller actions take care of needed session manipulation from within
  the LiveView modules.

  There is no other way to change session data via a websocket.

  The actions need to be protected to not enable tampering with session data.
  """

  use DealogBackofficeWeb, :controller

  alias DealogBackoffice.Accounts
  alias DealogBackofficeWeb.UserAuth

  def relogin_after_password_change(conn, %{"email" => email, "password" => password}) do
    user = Accounts.get_user_by_email_and_password(email, password)

    conn
    |> UserAuth.log_in_user_without_redirect(user)
    |> put_status(204)
    |> text("")
  end
end
