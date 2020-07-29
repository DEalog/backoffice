defmodule DealogBackofficeWeb.BannerError do
  use DealogBackofficeWeb, :live_component

  @impl true
  def mount(socket) do
    {:ok, socket}
  end
end
