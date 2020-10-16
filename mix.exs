defmodule DealogBackoffice.MixProject do
  use Mix.Project

  def project do
    [
      app: :dealog_backoffice,
      version: "0.5.0-dev",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      releases: [
        backoffice: [
          include_executables_for: [:unix],
          steps: [:assemble, :tar]
        ]
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {DealogBackoffice.Application, []},
      extra_applications: [:timex, :eventstore, :logger, :runtime_tools, :os_mon]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:bcrypt_elixir, "~> 2.0"},
      {:commanded, "~> 1.1"},
      {:commanded_ecto_projections, "~> 1.1"},
      {:commanded_eventstore_adapter, "~> 1.1"},
      {:csv, "~> 2.3"},
      {:earmark, "~> 1.4"},
      {:ecto_sql, "~> 3.4"},
      {:elixir_uuid, "~> 1.2"},
      {:eventstore, "~> 1.1"},
      {:exconstructor, "~> 1.1"},
      {:floki, ">= 0.0.0", only: :test},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.1"},
      {:kafka_ex, "~> 0.11"},
      {:map_diff, "~> 1.3"},
      {:mix_test_watch, "~> 1.0", only: :dev, runtime: false},
      {:phoenix, "~> 1.5.3"},
      {:phoenix_ecto, "~> 4.1"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_dashboard, "~> 0.2.9"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.14.0"},
      {:plug_cowboy, "~> 2.0"},
      {:postgrex, ">= 0.0.0"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:timex, "~> 3.0"},
      {:tzdata, "~> 1.0"},
      {:vex, "~> 0.6"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "cmd npm install --prefix assets"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "event_store.reset": ["event_store.drop", "event_store.setup"],
      "event_store.setup": ["event_store.create", "event_store.init"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end
end
