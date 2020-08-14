defmodule DealogBackofficeWeb.NotificationSuccess do
  use DealogBackofficeWeb, :live_component

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(assigns, socket) do
    socket =
      assign(socket,
        title: assigns.title,
        message: assigns.message,
        close_automatically?: Map.get(assigns, :close_automatically?, false),
        reopen_after_close?: Map.get(assigns, :reopen_after_close?, false),
        class: Map.get(assigns, :class, "")
      )

    {:ok, socket}
  end
end
