IO.puts("This script will reset the projection for messages")

if Mix.env() == :dev do
  alias DealogBackoffice.{Repo, EventStore}

  truncate_query = "TRUNCATE TABLE messages RESTART IDENTITY;"
  Ecto.Adapters.SQL.query!(Repo, truncate_query)

  IO.puts("✓ Truncated table messages")

  delete_projection_version_query = """
    DELETE FROM projection_versions
      WHERE projection_name = 'Messages.Projectors.Message';
  """

  Ecto.Adapters.SQL.query!(Repo, delete_projection_version_query)

  IO.puts("✓ Removed projection version")

  :ok = EventStore.delete_subscription("$all", "Messages.Projectors.Message")

  IO.puts("✓ Removed projection subscription")

  IO.puts("""
    Best is to restart the application (stack).
    Altertively you can run the following in the main IEx shell:

  [pid] =
  Enum.filter(
    Process.list(),
    &(Keyword.get(Process.info(&1), :registered_name) == DealogBackoffice.Messages.Supervisor)
  )

  Process.exit(pid, :kill)
  """)
end
