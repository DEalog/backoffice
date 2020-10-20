defmodule DealogBackofficeWeb.ReadmeLive do
  use DealogBackofficeWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    socket =
      socket
      |> assign_defaults(session)
      |> assign(
        page_title: gettext("Readme"),
        active_page: :readme,
        readme: readme()
      )

    {:ok, socket}
  end

  defp readme do
    "README.md"
    |> File.read!()
    |> Earmark.as_html!()
  end
end
