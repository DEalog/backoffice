defmodule DealogBackofficeWeb.AuthHelpers do
  @moduledoc """
  Helpers for account related functions.
  """

  def is_account_complete?(%DealogBackoffice.Accounts.User{account: nil}), do: false
  def is_account_complete?(_), do: true

  def is_account_incomplete?(%DealogBackoffice.Accounts.User{account: nil}), do: true
  def is_account_incomplete?(_), do: false
end
