defmodule DealogBackofficeWeb.ColorsComponent do
  use DealogBackofficeWeb, :live_component

  alias DealogBackoffice.DesignSystem

  @impl true
  def mount(socket) do
    socket = assign(socket, colors: display_colors())
    {:ok, socket, temporary_assigns: [colors: []]}
  end

  defp display_colors do
    DesignSystem.list_colors()
  end

  def upcase_first(<<first::utf8, rest::binary>>), do: String.upcase(<<first::utf8>>) <> rest
end
