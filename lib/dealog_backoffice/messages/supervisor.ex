defmodule DealogBackoffice.Messages.Supervisor do
  use Supervisor

  alias DealogBackoffice.Messages.Projectors

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    Supervisor.init(
      [
        Projectors.Message,
        Projectors.MessageApproval,
        Projectors.DeletedMessage,
        Projectors.PublishedMessage
      ],
      strategy: :one_for_one
    )
  end
end
