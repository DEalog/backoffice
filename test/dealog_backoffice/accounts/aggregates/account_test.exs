defmodule DealogBackoffice.Accounts.Aggregates.AccountTest do
  use DealogBackoffice.AggregateCase, aggregate: DealogBackoffice.Accounts.Aggregates.Account

  alias DealogBackoffice.Accounts.Commands.{CreateAccount, ChangePersonalData}
  alias DealogBackoffice.Accounts.Events.{AccountCreated, PersonalDataChanged}

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
            last_name: "Doe",
            user_id: ""
          }
        ]
      )
    end
  end

  describe "change personal data" do
    @tag :unit
    test "should successfully change when valid" do
      account_id = UUID.uuid4()

      assert_events(
        [
          %AccountCreated{
            account_id: account_id,
            first_name: "John",
            last_name: "Doe",
            user_id: ""
          }
        ],
        struct(ChangePersonalData, %{first_name: "Johnny", last_name: "Doesy"}),
        [
          %PersonalDataChanged{
            account_id: account_id,
            first_name: "Johnny",
            last_name: "Doesy"
          }
        ]
      )
    end
  end
end
