# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :dealog_backoffice,
  ecto_repos: [DealogBackoffice.Repo]

config :dealog_backoffice,
       DealogBackofficeWeb.Gettext,
       locales: ~w(de en),
       default_locale: "de"

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

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
