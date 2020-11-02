defmodule DealogBackoffice.Accounts.Supervisor do
  use Supervisor

  alias DealogBackoffice.Accounts.Projectors

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    Supervisor.init(projectors(), strategy: :one_for_one)
  end

  defp projectors do
    [
      Projectors.Account
    ]
  end
end
