defmodule DealogBackofficeWeb.LiveHelpers do
  @moduledoc """
  Helper funtions for LiveView modules.
  """

  import Phoenix.LiveView

  alias DealogBackoffice.Accounts
  alias DealogBackofficeWeb.Router.Helpers, as: Routes

  @doc """
  Assign the defaults like the current user and other session data to the socket.
  """
  def assign_defaults(socket, %{"user_token" => user_token}) do
    socket =
      assign_new(socket, :current_user, fn -> Accounts.get_user_by_session_token(user_token) end)

    if socket.assigns.current_user.confirmed_at do
      socket
    else
      redirect(socket, to: Routes.user_session_path(socket, :new))
    end
  end
end
