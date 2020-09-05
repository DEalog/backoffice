IO.puts("This script will reset the projections.")

alias DealogBackoffice.{Repo, EventStore}

truncate_projection_table = fn table ->
  truncate_query = "TRUNCATE TABLE #{table} RESTART IDENTITY;"
  Ecto.Adapters.SQL.query!(Repo, truncate_query)
  IO.puts("✓ Truncated table #{table}")
end

delete_projection_versions = fn name ->
  delete_projection_version_query = """
    DELETE FROM projection_versions
      WHERE projection_name = '#{name}';
  """

  Ecto.Adapters.SQL.query!(Repo, delete_projection_version_query)

  IO.puts("✓ Removed projection version for #{name}")
end

delete_subscription = fn name ->
  :ok = EventStore.delete_subscription("$all", name)
  IO.puts("✓ Removed projection subscription for #{name}")
end

if Mix.env() == :dev do
  projections = [
    %{table: "messages", name: "Messages.Projectors.Message"},
    %{table: "deleted_messages", name: "Messages.Projectors.DeletedMessage"},
    %{table: "message_approvals", name: "Messages.Projectors.MessageApproval"}
  ]

  Enum.each(projections, fn %{table: table, name: name} ->
    truncate_projection_table.(table)
    delete_projection_versions.(name)
    delete_subscription.(name)
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
  """)
else
  IO.puts("This script is only meant for development.")
end
