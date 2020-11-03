defmodule DealogBackoffice.Accounts.Validators.UnlinkedUserIdTest do
  use DealogBackoffice.DataCase

  import DealogBackoffice.AccountsFixtures

  alias DealogBackoffice.Accounts.Validators.UnlinkedUserId

  test "should pass if user is not already linked" do
    user = user_fixture()
    assert :ok = UnlinkedUserId.validate(user.id, %{})
  end

  test "should return error when user is already linked to an account" do
    user = user_fixture()

    create_account_and_link_user(user)

    assert {:error, "already linked to an account"} = UnlinkedUserId.validate(user.id, %{})
  end

  test "should return error when user_id is invalid" do
    assert {:error, "already linked to an account"} = UnlinkedUserId.validate(nil, %{})
  end
end
