defmodule DealogBackoffice.Accounts.UserNotifierTest do
  use DealogBackoffice.DataCase

  import Swoosh.TestAssertions
  import DealogBackoffice.AccountsFixtures

  alias DealogBackoffice.Accounts.UserNotifier

  test "send confirmation email" do
    user = user_fixture()
    url = "/url"

    assert {:ok, mail} = UserNotifier.deliver_confirmation_instructions(user, url)

    assert_email_sent(mail)
    assert mail.to == [{"", user.email}]
    assert mail.text_body =~ user.email
    assert mail.text_body =~ url
    assert mail.text_body =~ "confirm your account"
  end

  test "send password reset email" do
    user = user_fixture()
    url = "/url"

    assert {:ok, mail} = UserNotifier.deliver_reset_password_instructions(user, url)

    assert_email_sent(mail)
    assert mail.to == [{"", user.email}]
    assert mail.text_body =~ user.email
    assert mail.text_body =~ url
    assert mail.text_body =~ "reset your password"
  end

  test "send update email message" do
    user = user_fixture()
    url = "/url"

    assert {:ok, mail} = UserNotifier.deliver_update_email_instructions(user, url)

    assert mail.to == [{"", user.email}]
    assert mail.text_body =~ user.email
    assert mail.text_body =~ url
    assert mail.text_body =~ "change your email"
  end
end
