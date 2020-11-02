defmodule DealogBackoffice.Accounts.Events.AccountCreated do
  @derive Jason.Encoder
  defstruct [
    :account_id,
    :first_name,
    :last_name,
    :user_id
  ]
end
