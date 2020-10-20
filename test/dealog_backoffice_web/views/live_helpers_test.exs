defmodule DealogBackofficeWeb.LiveHelpersTest do
  use DealogBackofficeWeb.ConnCase

  import Phoenix.LiveViewTest

  describe "confirmed user" do
    setup :register_and_log_in_user

    test "assign current user to session", %{conn: conn, user: user} do
      {:ok, _view, html} = live_isolated(conn, __MODULE__.TestLive)

      assert html =~ user.email
    end
  end

  describe "unconfirmed user" do
    setup :register_user

    test "no user is assigned if logged out", %{conn: conn} do
      assert {:error, {:redirect, %{to: "/users/log_in"}}} =
               live_isolated(conn, __MODULE__.TestLive)
    end
  end

  defmodule TestLive do
    use Phoenix.LiveView

    import DealogBackofficeWeb.LiveHelpers

    def mount(_params, session, socket) do
      {:ok, assign_defaults(socket, session)}
    end

    def render(assigns) do
      ~L"""
      <%= @current_user.email %>
      """
    end
  end
end
