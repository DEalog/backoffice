defmodule DealogBackofficeWeb.FooterComponent do
  use DealogBackofficeWeb, :live_component

  @impl true
  def mount(socket) do
    socket =
      assign(socket,
        current_year: display_year(),
        version: display_version(),
        revision: display_revision()
      )

    {:ok, socket}
  end

  defp display_year do
    today = DateTime.utc_now()
    today.year
  end

  defp display_version do
    {:ok, vsn} = :application.get_key(:dealog_backoffice, :vsn)
    List.to_string(vsn)
  end

  defp display_revision do
    case System.fetch_env("GIT_REV") do
      :error ->
        "development"

      {:ok, rev} ->
        rev
        |> String.slice(0..7)
    end
  end
end
