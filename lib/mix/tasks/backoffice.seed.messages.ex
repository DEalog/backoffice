defmodule Mix.Tasks.Backoffice.Seed.Messages do
  use Mix.Task

  @shortdoc "Seed the Backoffice with random messages."

  @impl true
  def run(_) do
    IO.puts("Generating random messages...")
    Mix.Task.run("app.start")
    DealogBackoffice.Seed.messages()
  end
end
