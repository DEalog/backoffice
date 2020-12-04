defmodule DealogBackoffice.Support.ProjectionRebuilder do
  alias DealogBackoffice.{Repo, EventStore}

  def truncate_projection_table(table) do
    truncate_query = "TRUNCATE TABLE #{table} RESTART IDENTITY;"
    Ecto.Adapters.SQL.query!(Repo, truncate_query)
  end

  def delete_projection_versions(name) do
    delete_projection_version_query = """
      DELETE FROM projection_versions
        WHERE projection_name = '#{name}';
    """

    Ecto.Adapters.SQL.query!(Repo, delete_projection_version_query)
  end

  def delete_subscription(name) do
    :ok = EventStore.delete_subscription("$all", name)
  end

  def reload_messages_projection_supervisor do
    [pid] =
      Enum.filter(
        Process.list(),
        &(Keyword.get(Process.info(&1), :registered_name) == DealogBackoffice.Messages.Supervisor)
      )

    Process.exit(pid, :kill)
  end

  def reload_account_projection_supervisor do
    [pid] =
      Enum.filter(
        Process.list(),
        &(Keyword.get(Process.info(&1), :registered_name) == DealogBackoffice.Accounts.Supervisor)
      )

    Process.exit(pid, :kill)
  end

  def rebuild_messages do
    projections = [
      %{table: "messages", name: "Messages.Projectors.Message"},
      %{table: "deleted_messages", name: "Messages.Projectors.DeletedMessage"},
      %{table: "message_approvals", name: "Messages.Projectors.MessageApproval"},
      %{table: "archived_messages", name: "Messages.Projectors.ArchivedMessage"}
    ]

    Enum.each(projections, fn %{table: table, name: name} ->
      truncate_projection_table(table)
      delete_projection_versions(name)
      delete_subscription(name)
    end)

    reload_messages_projection_supervisor()
  end

  def rebuild_accounts do
    projections = [
      %{table: "accounts", name: "Accounts.Projectors.Account"}
    ]

    Enum.each(projections, fn %{table: table, name: name} ->
      truncate_projection_table(table)
      delete_projection_versions(name)
      delete_subscription(name)
    end)

    reload_account_projection_supervisor()
  end
end
