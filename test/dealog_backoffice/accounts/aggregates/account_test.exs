defmodule DealogBackoffice.Accounts.Aggregates.AccountTest do
  use DealogBackoffice.AggregateCase, aggregate: DealogBackoffice.Accounts.Aggregates.Account

  alias DealogBackoffice.Accounts.Commands.CreateAccount
  alias DealogBackoffice.Accounts.Events.AccountCreated

  describe "create account" do
    @tag :unit
    test "should successfully build when valid" do
      account_id = UUID.uuid4()

      assert_events(
        struct(CreateAccount, %{account_id: account_id, first_name: "John", last_name: "Doe"}),
        [
          %AccountCreated{
            account_id: account_id,
            first_name: "John",
            last_name: "Doe"
          }
        ]
      )
    end
  end
end
