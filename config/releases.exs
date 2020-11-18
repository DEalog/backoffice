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
  projectors: String.to_existing_atom(System.get_env("PROJECTORS") || "all")

kafka_hosts =
  System.get_env("KAFKA_HOSTS") ||
    raise """
        environment variable KAFKA_HOSTS is missing.
        For example: localhost:9092,localhost:9093,localhost:9094
    """

config :kafka_ex,
  brokers: kafka_hosts

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

smtp_relay =
  System.get_env("SMTP_RELAY") ||
    raise """
        environment variable SMTP_RELAY is missing.
        For example: mail.domain.tld
    """

smtp_port =
  System.get_env("SMTP_PORT") ||
    raise """
        environment variable SMTP_PORT is missing.
        For example: 587
    """

smtp_username =
  System.get_env("SMTP_USERNAME") ||
    raise """
        environment variable SMTP_USERNAME is missing.
        For example: mail@domain.tld
    """

smtp_password =
  System.get_env("SMTP_PASSWORD") ||
    raise """
        environment variable SMTP_PASSWORD is missing.
        For example: s3c3tP4ssw0Rd
    """

# Swoosh mailing
config :dealog_backoffice, DealogBackoffice.Accounts.Mailer,
  adapter: Swoosh.Adapters.SMTP,
  relay: smtp_relay,
  port: smtp_port,
  username: smtp_username,
  password: smtp_password

# Super user settings
config :dealog_backoffice, :super_user,
  email: System.get_env("SUPER_USER_EMAIL"),
  password: System.get_env("SUPER_USER_PASSWORD")
