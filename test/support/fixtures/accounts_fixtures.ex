defmodule DealogBackoffice.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `DealogBackoffice.Accounts` context.
  """

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hello world!"

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: unique_user_email(),
        password: valid_user_password()
      })
      |> DealogBackoffice.Accounts.register_user()

    user
  end

  def confirmed_user_fixture(attrs \\ %{}) do
    user = user_fixture(attrs)
    DealogBackoffice.AccountTestHelpers.confirm_user(user)

    user
  end

  def extract_user_token(fun) do
    {:ok, captured} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token, _] = String.split(captured.text_body, "[TOKEN]")
    token
  end

  def create_account_and_link_user(user) do
    DealogBackoffice.Accounts.create_account(%{
      first_name: "John",
      last_name: "Doe",
      user_id: user.id,
      administrative_area: "abc"
    })
  end
end
