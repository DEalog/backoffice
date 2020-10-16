defmodule DealogBackofficeWeb.MyAccountLive.IndexTest do
  use DealogBackofficeWeb.ConnCase

  import Phoenix.LiveViewTest
  import DealogBackoffice.AccountsFixtures

  alias DealogBackoffice.Accounts

  setup :register_and_log_in_user

  describe "GET /my-account" do
    test "renders settings page", %{conn: conn} do
      {:ok, view, html} = live(conn, "/my-account")
      assert html =~ "My account"
      assert render(view) =~ "My account"
    end

    test "redirects if user is not logged in" do
      conn = build_conn()
      {:error, {:redirect, %{to: path}}} = live(conn, "/my-account")
      assert path == Routes.user_session_path(conn, :new)
    end
  end

  describe "Change password" do
    test "update_password updates the user password and resets token", %{conn: conn} do
      {:ok, view, _} = live(conn, "/my-account")

      result =
        view
        |> form("[phx-submit='update_password']", %{
          "current_password" => valid_user_password(),
          "user" => %{
            "password" => "new valid password",
            "password_confirmation" => "new valid password"
          }
        })
        |> render_submit()

      assert result =~ "Password was successfully updated."

      assert_push_event(view, "relogin", sent_payload)
      assert %{password: "new valid password"} = sent_payload
      assert Accounts.get_user_by_email_and_password(sent_payload.email, sent_payload.password)

      # Internal behavior via push_event that performs a relogin via the client to rebuild the session
      # TODO Check if this can be solved better
      new_conn =
        post(conn, Routes.user_api_path(conn, :relogin_after_password_change), sent_payload)

      assert get_session(new_conn, :user_token) != get_session(conn, :user_token)
    end

    test "update_password does not update on invalid data", %{conn: conn} do
      {:ok, view, _} = live(conn, "/my-account")

      result =
        view
        |> form("[phx-submit='update_password']", %{
          "current_password" => "invalid",
          "user" => %{
            "password" => "too short",
            "password_confirmation" => "does not match"
          }
        })
        |> render_submit()

      assert result =~ "Check errors in the form fields below."
      assert result =~ "should be at least 12 character(s)"
      assert result =~ "does not match password"
      assert result =~ "is not valid"
    end
  end

  describe "Change email" do
    @tag :capture_log
    test "update_email updates the user email", %{conn: conn} do
      {:ok, view, _} = live(conn, "/my-account")

      result =
        view
        |> form("[phx-submit='update_email']", %{
          "current_password" => valid_user_password(),
          "user" => %{"email" => unique_user_email()}
        })
        |> render_submit()

      assert result =~
               "Email address was successfully changed. Please check your email account for a confirmation email and click the link."
    end

    test "update_email does not update the user email on invalid data", %{conn: conn} do
      {:ok, view, _} = live(conn, "/my-account")

      result =
        view
        |> form("[phx-submit='update_email']", %{
          "current_password" => "invalid",
          "user" => %{"email" => "with spaces"}
        })
        |> render_submit()

      assert result =~ "Check errors in the form fields below."
      assert result =~ "must have the @ sign and no spaces"
      assert result =~ "is not valid"
    end

    test "update_email does not update the user email when not changed", %{conn: conn, user: user} do
      {:ok, view, _} = live(conn, "/my-account")

      result =
        view
        |> form("[phx-submit='update_email']", %{
          "current_password" => valid_user_password(),
          "user" => %{"email" => user.email}
        })
        |> render_submit()

      assert result =~ "Check errors in the form fields below."
      assert result =~ "did not change"
    end
  end
end
