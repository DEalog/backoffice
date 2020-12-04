defmodule DealogBackoffice.Release do
  @moduledoc """
  Functions for running one-off tasks on a released version of the backoffice.
  """

  require Logger

  @app :dealog_backoffice

  @doc """
  Ensure event store is setup and initialized.
  """
  def init_event_store do
    Logger.info("Checking event store setup")
    load_app()

    config = EventStore.Config.parsed(DealogBackoffice.EventStore, @app)

    EventStore.Tasks.Create.exec(config, quiet: true)
    :ok = EventStore.Tasks.Init.exec(DealogBackoffice.EventStore, config, quiet: true)
    Logger.info("Event store setup finished")
  end

  @doc """
  Apply database migrations.
  """
  def migrate do
    Logger.info("Checking for migrations")
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end

    Logger.info("Migrations done")
  end

  @doc """
  Rollback database migrations.
  """
  def rollback(repo, version) do
    Logger.error("Rolling back migration #{repo} to version #{version}")
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
    Logger.error("Migration reverted")
  end

  @doc """
  Import the list of administrative areas.
  """
  def import_administrative_areas do
    Logger.info("Loading administrative areas")
    load_app()
    {:ok, _} = Application.ensure_all_started(:dealog_backoffice)

    :dealog_backoffice
    |> Application.app_dir(["priv", "repo", "administrative_areas"])
    |> DealogBackoffice.Importer.AdministrativeAreas.import_all_from()

    Logger.info("Administrative areas loaded")
  end

  @doc """
  Creates a super user if not already created.
  """
  def create_super_user do
    Logger.info("Ensuring super user")
    load_app()
    {:ok, _} = Application.ensure_all_started(:dealog_backoffice)

    case super_user_config() do
      {:ok, [email: email, password: password]} ->
        DealogBackoffice.Importer.SuperUser.create(%{email: email, password: password})

      :error ->
        nil
    end

    Logger.info("Super user set up")
  end

  @doc """
  Rebuild the messages related projections.
  """
  def rebuild_messages_projections do
    Logger.info("Rebuilding messages projections")
    load_app()
    {:ok, _} = Application.ensure_all_started(:dealog_backoffice)

    DealogBackoffice.Support.ProjectionRebuilder.rebuild_messages()
    Logger.info("Messages projections rebuilt")
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    {:ok, _} = Application.ensure_all_started(:postgrex)
    {:ok, _} = Application.ensure_all_started(:ssl)

    :ok = Application.load(@app)
  end

  defp super_user_config do
    Application.fetch_env(@app, :super_user)
  end
end
