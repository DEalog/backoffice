defmodule DealogBackoffice.Accounts.Events.OrganizationalSettingsChanged do
  @derive Jason.Encoder
  defstruct [
    :account_id,
    :administrative_area,
    :organization,
    :position
  ]
end
