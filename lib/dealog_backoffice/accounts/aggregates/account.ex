defmodule DealogBackoffice.Accounts.Aggregates.Account do
  defstruct [
    :account_id,
    :first_name,
    :last_name,
    :user_id,
    :organization,
    :administrative_area
  ]

  alias DealogBackoffice.Accounts.Aggregates.Account

  alias DealogBackoffice.Accounts.Commands.CreateAccount

  alias DealogBackoffice.Accounts.Events.AccountCreated

  def execute(%Account{account_id: nil}, %CreateAccount{} = create) do
    %AccountCreated{
      account_id: create.account_id,
      first_name: create.first_name,
      last_name: create.last_name,
      user_id: create.user_id
    }
  end

  def apply(%Account{} = account, %AccountCreated{} = created) do
    %Account{
      account
      | account_id: created.account_id,
        first_name: created.first_name,
        last_name: created.last_name,
        user_id: created.user_id
    }
  end
end
