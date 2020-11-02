defmodule DealogBackoffice.Accounts.Validators.UniqueAccountIdTest do
  use DealogBackoffice.DataCase

  alias DealogBackoffice.Accounts
  alias DealogBackoffice.Accounts.Validators.UniqueAccountId

  test "should pass if unique" do
    assert :ok = UniqueAccountId.validate(UUID.uuid4(), %{})
  end

  test "should return error when not unique" do
    {:ok, account} = Accounts.create_account(%{first_name: "John", last_name: "Doe"})

    assert {:error, "has already been created"} = UniqueAccountId.validate(account.id, %{})
  end
end
