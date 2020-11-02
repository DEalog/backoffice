defmodule DealogBackoffice.Accounts.Projectors.Account do
  use Commanded.Projections.Ecto,
    application: DealogBackoffice.App,
    name: "Accounts.Projectors.Account",
    consistency: :strong

  alias DealogBackoffice.Accounts.Events.AccountCreated
  alias DealogBackoffice.Accounts.Projections.Account

  project(%AccountCreated{} = created, metadata, fn multi ->
    Ecto.Multi.insert(
      multi,
      :account,
      %Account{
        id: created.account_id,
        first_name: created.first_name,
        last_name: created.last_name,
        inserted_at: metadata.created_at
      }
    )
  end)
end
