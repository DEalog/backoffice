# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

default_locale = "de"
timezone = "Europe/Berlin"
date_time_format = "{0D}.{0M}.{YYYY} {h24}:{m}:{s}"
date_format = "{0D}.{0M}.{YYYY}"

config :dealog_backoffice,
  ecto_repos: [DealogBackoffice.Repo],
  event_stores: [DealogBackoffice.EventStore]

config :dealog_backoffice, DealogBackoffice.App,
  event_store: [
    adapter: Commanded.EventStore.Adapters.EventStore,
    event_store: DealogBackoffice.EventStore
  ],
  pub_sub: :local,
  registry: :local

config :commanded_ecto_projections,
  repo: DealogBackoffice.Repo

# The projectors can be defined here.
#
# This is mainly to keep deployment ability as the infrastructure needs to
# provide additional services and in the test env the remote projections are
# not started to keep it more simple.
#
# Implemented sets of projectors are
# - `:local` for local projectors
# - `:all` to also include remote projectors like Kafka
config :dealog_backoffice, :projection, projectors: :local

config :vex,
  sources: [
    DealogBackoffice.Validators,
    DealogBackoffice.Messages.Validators,
    DealogBackoffice.Accounts.Validators,
    Vex.Validators
  ]

config :dealog_backoffice, DealogBackofficeWeb.Gettext,
  locales: ~w(de en),
  default_locale: default_locale

config :dealog_backoffice, DealogBackoffice.Gettext,
  locales: ~w(de en),
  default_locale: default_locale

config :dealog_backoffice, :i18n,
  locale: default_locale,
  timezone: timezone,
  date_time_format: date_time_format,
  date_format: date_format

# Configures the endpoint
config :dealog_backoffice, DealogBackofficeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "8HioD6t+/uSbR0G50nTNv1UQNwjrtglJ+gn0eFLyhQ6fyPUUMa3WTq9JmbG+ki7X",
  render_errors: [view: DealogBackofficeWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: DealogBackoffice.PubSub,
  live_view: [signing_salt: "d2buOMuU"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configure event store
config :commanded,
  event_store_adapter: Commanded.EventStore.Adapters.EventStore

# Configure tzdata
config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

config :iex, default_prompt: "DEalog IEx>>>"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
