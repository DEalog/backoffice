defmodule DealogBackoffice.Accounts.Validators.ExistingUserIdTest do
  use DealogBackoffice.DataCase

  import DealogBackoffice.AccountsFixtures

  alias DealogBackoffice.Accounts.Validators.ExistingUserId

  test "should pass if user exists" do
    user = user_fixture()
    assert :ok = ExistingUserId.validate(user.id, %{})
  end

  test "should return error when user does not exist" do
    assert {:error, "does not exist"} = ExistingUserId.validate(UUID.uuid4(), %{})
  end

  test "should return error when input is invalid" do
    assert {:error, "does not exist"} = ExistingUserId.validate(nil, %{})
  end
end
