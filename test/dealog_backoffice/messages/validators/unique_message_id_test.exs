defmodule DealogBackoffice.Accounts.Validators.UniqueAccountIdTest do
  use DealogBackoffice.DataCase

  import DealogBackoffice.AccountsFixtures

  alias DealogBackoffice.Accounts
  alias DealogBackoffice.Accounts.Validators.UniqueAccountId

  test "should pass if unique" do
    assert :ok = UniqueAccountId.validate(UUID.uuid4(), %{})
  end

  test "should return error when not unique" do
    user = user_fixture()

    {:ok, account} =
      Accounts.create_account(%{first_name: "John", last_name: "Doe", user_id: user.id})

    assert {:error, "has already been created"} = UniqueAccountId.validate(account.id, %{})
  end
end
