defmodule Mix.Tasks.Backoffice.Seed.DevUser do
  use Mix.Task

  @shortdoc "Seed the Backoffice with a development user."

  @impl true
  def run(_) do
    IO.puts("Creating development user...")
    Mix.Task.run("app.start")
    DealogBackoffice.Seed.dev_user()

    IO.puts("""
      **********************************************************
      *
      * Please use "dev@dealog.de" and "password1234" to login.
      *
      **********************************************************
    """)
  end
end
