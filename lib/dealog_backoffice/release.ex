defmodule DealogBackoffice.Release do
  @app :dealog_backoffice

  def init_event_store do
    load_app()

    config = EventStore.Config.parsed(DealogBackoffice.EventStore, @app)

    :ok = EventStore.Tasks.Create.exec(config, [])
    :ok = EventStore.Tasks.Init.exec(DealogBackoffice.EventStore, config, [])
  end

  def migrate do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
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
