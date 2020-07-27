defmodule DealogBackofficeWeb.NavigationComponent do
  use DealogBackofficeWeb, :live_component

  alias DealogBackofficeWeb.Router.Helpers, as: Routes

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  def get_style(page, current_page, active_style, _) when page == current_page, do: active_style
  def get_style(_, _, _, inactive_style), do: inactive_style

  def get_mobile_style(page, current_page, mobile_active_style, _) when page == current_page,
    do: mobile_active_style

  def get_mobile_style(_, _, _, mobile_inactive_style), do: mobile_inactive_style
end
