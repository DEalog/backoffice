defmodule DealogBackoffice.Accounts.Aggregates.AccountTest do
  use DealogBackoffice.AggregateCase, aggregate: DealogBackoffice.Accounts.Aggregates.Account

  alias DealogBackoffice.Accounts.Commands.{
    CreateAccount,
    ChangePersonalData,
    ChangeOrganizationalSettings
  }

  alias DealogBackoffice.Accounts.Events.{
    AccountCreated,
    PersonalDataChanged,
    OrganizationalSettingsChanged
  }

  describe "create account" do
    @tag :unit
    test "should successfully build when valid personal data is present" do
      account_id = UUID.uuid4()
      user_id = UUID.uuid4()

      assert_events(
        struct(CreateAccount, %{
          account_id: account_id,
          first_name: "John",
          last_name: "Doe",
          user_id: user_id
        }),
        [
          %AccountCreated{
            account_id: account_id,
            first_name: "John",
            last_name: "Doe",
            user_id: user_id,
            administrative_area: "",
            organization: "",
            position: ""
          }
        ]
      )
    end

    test "should successfully build when valid personal data and organizational settings are present" do
      account_id = UUID.uuid4()
      user_id = UUID.uuid4()

      assert_events(
        struct(CreateAccount, %{
          account_id: account_id,
          first_name: "John",
          last_name: "Doe",
          user_id: user_id,
          administrative_area: "An area",
          organization: "An org",
          position: "A pos"
        }),
        [
          %AccountCreated{
            account_id: account_id,
            first_name: "John",
            last_name: "Doe",
            user_id: user_id,
            administrative_area: "An area",
            organization: "An org",
            position: "A pos"
          }
        ]
      )
    end

    @tag :unit
    test "should fail when no user ID is passed" do
      account_id = UUID.uuid4()

      assert_error(
        struct(CreateAccount, %{
          account_id: account_id,
          first_name: "John",
          last_name: "Doe",
          user_id: ""
        }),
        {:error, :missing_user_id}
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

  describe "change organizational settings" do
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
        struct(ChangeOrganizationalSettings, %{
          administrative_area: "123",
          organization: "An organization",
          position: "A position"
        }),
        [
          %OrganizationalSettingsChanged{
            account_id: account_id,
            administrative_area: "123",
            organization: "An organization",
            position: "A position"
          }
        ]
      )
    end
  end
end
