defmodule DealogBackoffice.Repo do
  use Ecto.Repo,
    otp_app: :dealog_backoffice,
    adapter: Ecto.Adapters.Postgres
end
