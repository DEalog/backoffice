import Config

database_url =
  System.get_env("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

event_store_database_url =
  System.get_env("EVENT_STORE_DATABASE_URL") ||
    raise """
    environment variable EVENT_STORE_DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

config :dealog_backoffice, DealogBackoffice.Repo,
  migration_timestamps: [type: :utc_datetime_usec],
  # ssl: true,
  url: database_url,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

config :dealog_backoffice, DealogBackoffice.EventStore,
  # ssl: true,
  url: event_store_database_url,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

config :dealog_backoffice, :projection,
  projectors: String.to_atom(System.get_env("PROJECTORS")) || :all

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :dealog_backoffice, DealogBackofficeWeb.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT") || "4000"),
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: secret_key_base

config :dealog_backoffice, DealogBackofficeWeb.Endpoint, server: true
