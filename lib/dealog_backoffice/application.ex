defmodule DealogBackoffice.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      DealogBackoffice.Repo,
      # Start the Telemetry supervisor
      DealogBackofficeWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: DealogBackoffice.PubSub},
      # Start the Endpoint (http/https)
      DealogBackofficeWeb.Endpoint
      # Start a worker by calling: DealogBackoffice.Worker.start_link(arg)
      # {DealogBackoffice.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DealogBackoffice.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    DealogBackofficeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
