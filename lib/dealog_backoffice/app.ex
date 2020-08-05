
defmodule DealogBackoffice.App do
  use Commanded.Application, otp_app: :dealog_backoffice

  router DealogBackoffice.Router
end
