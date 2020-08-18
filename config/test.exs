use Mix.Config

config :dealog_backoffice, DealogBackofficeWeb.Gettext, default_locale: "en"

config :dealog_backoffice, :i18n, locale: "en"

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :dealog_backoffice, DealogBackoffice.Repo,
  migration_timestamps: [type: :utc_datetime_usec],
  username: System.get_env("POSTGRES_USER") || "postgres",
  password: System.get_env("POSTGRES_PASSWORD") || "postgres",
  database:
    System.get_env("POSTGRES_DB") ||
      "dealog_backoffice_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: System.get_env("POSTGRES_HOST") || "db",
  pool: Ecto.Adapters.SQL.Sandbox

config :dealog_backoffice, DealogBackoffice.EventStore,
  serializer: EventStore.JsonSerializer,
  username: System.get_env("POSTGRES_USER") || "postgres",
  password: System.get_env("POSTGRES_PASSWORD") || "postgres",
  database:
    System.get_env("POSTGRES_DB") ||
      "dealog_backoffice_event_store_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: System.get_env("POSTGRES_HOST") || "db",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :dealog_backoffice, DealogBackofficeWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
