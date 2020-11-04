defmodule DealogBackoffice.Accounts.Events.PersonalDataChanged do
  @derive Jason.Encoder
  defstruct [
    :account_id,
    :first_name,
    :last_name
  ]
end
