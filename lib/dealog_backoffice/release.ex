defmodule DealogBackoffice.Release do
  @moduledoc """
  Functions for running one-off tasks on a released version of the backoffice.
  """

  @app :dealog_backoffice

  @doc """
  Ensure event store is setup and initialized.
  """
  def init_event_store do
    load_app()

    config = EventStore.Config.parsed(DealogBackoffice.EventStore, @app)

    :ok = EventStore.Tasks.Create.exec(config, [])
    :ok = EventStore.Tasks.Init.exec(DealogBackoffice.EventStore, config, [])
  end

  @doc """
  Apply database migrations.
  """
  def migrate do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  @doc """
  Rollback database migrations.
  """
  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  @doc """
  Import the list of administrative areas.
  """
  def import_administrative_areas do
    load_app()
    {:ok, _} = Application.ensure_all_started(:dealog_backoffice)

    :dealog_backoffice
    |> Application.app_dir(["priv", "repo", "administrative_areas"])
    |> DealogBackoffice.Importer.AdministrativeAreas.import_all_from()
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    {:ok, _} = Application.ensure_all_started(:postgrex)
    {:ok, _} = Application.ensure_all_started(:ssl)

    :ok = Application.load(@app)
  end
end
