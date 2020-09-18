use Mix.Config

config :dealog_backoffice, DealogBackofficeWeb.Endpoint,
  url: [host: {:system, "HOSTNAME"}],
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true,
  version: Application.spec(:dealog_backoffice, :vsn)

config :dealog_backoffice, DealogBackoffice.EventStore, serializer: EventStore.JsonSerializer

config :kafka_ex,
  kafka_version: "kayrock",
  client_id: "dealog_backoffice_kafka",
  disable_default_worker: true,
  brokers: [
    # TODO This needs to move to releases.exs
    {"kafka", 9092}
  ]

# Do not print debug messages in production
config :logger, level: :info

