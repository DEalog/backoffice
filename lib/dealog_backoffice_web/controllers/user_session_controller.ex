defmodule DealogBackofficeWeb.UserSessionController do
  @moduledoc """
  Controller holding functionality to login and logout.
  """

  use DealogBackofficeWeb, :controller

  alias DealogBackoffice.Accounts
  alias DealogBackofficeWeb.UserAuth

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    if user = Accounts.get_user_by_email_and_password(email, password) do
      UserAuth.log_in_user(conn, user, user_params)
    else
      conn
      |> put_flash(:error, gettext("Invalid email or password"))
      |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, gettext("Logged out successfully."))
    |> UserAuth.log_out_user()
  end
end
