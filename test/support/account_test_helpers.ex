defmodule DealogBackoffice.AccountTestHelpers do
  @doc """
  Setup helper that registers users.

      setup :register_user

  It stores an updated connection in the test context.
  """
  def register_user(%{conn: conn}) do
    user = DealogBackoffice.AccountsFixtures.user_fixture()

    %{conn: log_in_user(conn, user), user: user}
  end

  @doc """
  Setup helper that registers, confirms and logs in users.

      setup :register_and_log_in_user

  It stores an updated connection and a registered user in the
  test context.
  """
  def register_and_log_in_user(%{conn: conn}) do
    user = DealogBackoffice.AccountsFixtures.user_fixture()
    confirm_user(user)

    %{conn: log_in_user(conn, user), user: user}
  end

  def register_log_in_and_setup_user(%{conn: conn}) do
    user = DealogBackoffice.AccountsFixtures.user_fixture()
    confirm_user(user)
    DealogBackoffice.AccountsFixtures.create_account_and_link_user(user)

    %{conn: log_in_user(conn, user), user: user}
  end

  @doc """
  Confirm user registration. The user is only able to login / create a session
  once they confirmed their registration.
  """
  def confirm_user(user) do
    {encoded_token, user_token} =
      DealogBackoffice.Accounts.UserToken.build_email_token(user, "confirm")

    DealogBackoffice.Repo.insert!(user_token)
    DealogBackoffice.Accounts.confirm_user(encoded_token)
  end

  @doc """
  Logs the given `user` into the `conn`.

  It returns an updated `conn`.
  """
  def log_in_user(conn, user) do
    token = DealogBackoffice.Accounts.generate_user_session_token(user)

    conn
    |> Phoenix.ConnTest.init_test_session(%{})
    |> Plug.Conn.put_session(:user_token, token)
  end

  @doc """
  Extract the user from the session.
  """
  def get_user_from_session(conn) do
    conn
    |> Plug.Conn.get_session(:user_token)
    |> DealogBackoffice.Accounts.get_user_by_session_token()
  end

  @doc """
  Create an account for a given user.
  """
  def create_account_for_user(user) do
    {:ok, account} =
      DealogBackoffice.Accounts.create_account(%{
        first_name: "Han",
        last_name: "Solo",
        user_id: user.id,
        administrative_area: "abc"
      })

    account
  end
end
