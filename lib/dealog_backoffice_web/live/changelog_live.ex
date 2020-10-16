defmodule DealogBackofficeWeb.ChangelogLive do
  use DealogBackofficeWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    socket =
      socket
      |> assign_defaults(session)
      |> assign(
        page_title: gettext("Changelog"),
        active_page: :changelog,
        changelog: changelog()
      )

    {:ok, socket}
  end

  defp changelog do
    "CHANGELOG.md"
    |> File.read!()
    |> Earmark.as_html!()
  end
end
