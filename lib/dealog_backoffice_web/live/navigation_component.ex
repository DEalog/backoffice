defmodule DealogBackofficeWeb.NavigationComponent do
  use Phoenix.LiveComponent

  alias DealogBackofficeWeb.Router.Helpers, as: Routes

  @impl true
  def mount(socket) do
    {:ok, socket}
  end
end
