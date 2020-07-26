defmodule DealogBackofficeWeb.ReadmeLive do
  use DealogBackofficeWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket =
      assign(socket,
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
