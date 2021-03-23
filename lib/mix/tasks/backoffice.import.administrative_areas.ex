defmodule Mix.Tasks.Backoffice.Import.AdministrativeAreas do
  use Mix.Task

  alias DealogBackoffice.Importer.AdministrativeAreas

  @shortdoc "Import administrative areas to the Backoffice."

  @impl true
  def run(_) do
    IO.puts("Importing administrative areas...")
    Mix.Task.run("app.start")

    path = Path.expand(Application.app_dir(:dealog_backoffice, "priv/repo/administrative_areas"))
    IO.puts("Importing administrative areas from #{path}")
    amount = AdministrativeAreas.import_all_from(path)
    IO.puts("Imported #{amount} new administrative areas")
  end
end
