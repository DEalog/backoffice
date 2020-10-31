defmodule DealogBackofficeWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use DealogBackofficeWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import DealogBackofficeWeb.ConnCase
      import DealogBackofficeWeb.LiveViewTestHelpers

      alias DealogBackofficeWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint DealogBackofficeWeb.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(DealogBackoffice.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(DealogBackoffice.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

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

  def get_user_from_session(conn) do
    conn
    |> Plug.Conn.get_session(:user_token)
    |> DealogBackoffice.Accounts.get_user_by_session_token()
  end
end
