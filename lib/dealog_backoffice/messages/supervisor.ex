defmodule DealogBackoffice.Messages.Supervisor do
  use Supervisor

  alias DealogBackoffice.Messages.Projectors

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    Supervisor.init(
      projectors(),
      strategy: :one_for_one
    )
  end

  @local_projectors [
    Projectors.Message,
    Projectors.MessageHistory,
    Projectors.MessageApproval,
    Projectors.DeletedMessage,
    Projectors.PublishedMessage,
    Projectors.ArchivedMessage
  ]

  @additional_projectors [
    Projectors.MessageService
  ]

  defp projectors do
    case get_projector_config() do
      :all ->
        @local_projectors ++ @additional_projectors

      :local ->
        @local_projectors
    end
  end

  defp get_projector_config do
    Application.get_env(:dealog_backoffice, :projection)[:projectors]
  end
end
