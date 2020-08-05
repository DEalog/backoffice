defmodule DealogBackoffice.Messages.Supervisor do
  use Supervisor

  alias DealogBackoffice.Messages

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    Supervisor.init([Messages.Projectors.Message], strategy: :one_for_one)
  end
end
