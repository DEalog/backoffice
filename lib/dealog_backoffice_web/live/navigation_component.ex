defmodule DealogBackofficeWeb.NavigationComponent do
  use Phoenix.LiveComponent

  alias DealogBackofficeWeb.Router.Helpers, as: Routes

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  def get_style(page, current_page) when page == current_page, do: get_active_style()
  def get_style(_, _), do: get_inactive_style()

  defp get_active_style do
    "border-yellow-500 text-gray-900 focus:outline-none focus:border-yellow-700"
  end

  defp get_inactive_style do
    "border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 focus:outline-none focus:text-gray-700 focus:border-gray-300"
  end

  def get_mobile_style(page, current_page) when page == current_page,
    do: get_active_mobile_style()

  def get_mobile_style(_, _), do: get_inactive_mobile_style()

  defp get_active_mobile_style do
    "border-yellow-500 text-yellow-700 bg-yellow-100 focus:outline-none focus:text-yellow-800 focus:bg-yellow-100 focus:border-yellow-700"
  end

  defp get_inactive_mobile_style do
    "border-transparent text-gray-600 hover:text-gray-800 hover:bg-gray-50 hover:border-gray-300 focus:outline-none focus:text-gray-800 focus:bg-gray-50 focus:border-gray-300"
  end
end
