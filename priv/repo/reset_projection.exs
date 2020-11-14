defmodule DealogBackoffice.ResetProjections do
  alias DealogBackoffice.{Repo, EventStore}

  def truncate_projection_table(table) do
    truncate_query = "TRUNCATE TABLE #{table} RESTART IDENTITY;"
    Ecto.Adapters.SQL.query!(Repo, truncate_query)
    IO.puts("✓ Truncated table #{table}")
  end

  def delete_projection_versions(name) do
    delete_projection_version_query = """
      DELETE FROM projection_versions
        WHERE projection_name = '#{name}';
    """

    Ecto.Adapters.SQL.query!(Repo, delete_projection_version_query)

    IO.puts("✓ Removed projection version for #{name}")
  end

  def delete_subscription(name) do
    :ok = EventStore.delete_subscription("$all", name)
    IO.puts("✓ Removed projection subscription for #{name}")
  end
end

alias DealogBackoffice.ResetProjections

IO.puts("This script will reset the projections.")

should_run =
  case System.argv() do
    ["--run"] -> true
    ["--run", _] -> true
    _ -> false
  end

if Mix.env() == :dev or should_run do
  projections = [
    %{table: "messages", name: "Messages.Projectors.Message"},
    %{table: "deleted_messages", name: "Messages.Projectors.DeletedMessage"},
    %{table: "message_approvals", name: "Messages.Projectors.MessageApproval"},
    %{table: "accounts", name: "Accounts.Projectors.Account"}
  ]

  Enum.each(projections, fn %{table: table, name: name} ->
    ResetProjections.truncate_projection_table(table)
    ResetProjections.delete_projection_versions(name)
    ResetProjections.delete_subscription(name)
  end)

  IO.puts("""

  ****************************************************************************
  * Successfully wiped all projections.                                      *
  ****************************************************************************

  Best is to restart the application (stack).
  Alternatively you can run the following in the main IEx shell:

  [pid] =
  Enum.filter(
    Process.list(),
    &(Keyword.get(Process.info(&1), :registered_name) == DealogBackoffice.Messages.Supervisor)
  )

  Process.exit(pid, :kill)

  [pid] =
  Enum.filter(
    Process.list(),
    &(Keyword.get(Process.info(&1), :registered_name) == DealogBackoffice.Accounts.Supervisor)
  )

  Process.exit(pid, :kill)
  """)
else
  IO.puts("This script is only meant for development.")
end
