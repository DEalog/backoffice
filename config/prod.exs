use Mix.Config

config :dealog_backoffice, DealogBackofficeWeb.Endpoint,
  url: [host: {:system, "HOSTNAME"}],
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true,
  version: Application.spec(:dealog_backoffice, :vsn)

config :dealog_backoffice, DealogBackoffice.EventStore, serializer: EventStore.JsonSerializer

# Do not print debug messages in production
config :logger, level: :info

