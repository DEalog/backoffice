defmodule DealogBackofficeWeb.PreviewLive do
  use DealogBackofficeWeb, :preview_live_view

  @impl true
  def mount(params, session, socket) do
    params =
      for {key, val} <- params,
          into: %{},
          do: {String.to_atom(key), val}

    params =
      params
      |> Map.drop([:socket])
      |> Map.put(:component, :"#{Map.get(params, :component)}")
      |> Map.put(:active_page, "")
      |> Map.to_list()

    socket =
      socket
      |> assign_defaults(session)
      |> assign(params)

    {:ok, socket}
  end
end
