defmodule DealogBackofficeWeb.ChangelogLive do
  use DealogBackofficeWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket =
      assign(socket,
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
