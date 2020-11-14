defmodule DealogBackoffice.Accounts.Validators.UniqueAccountId do
  use Vex.Validator

  alias DealogBackoffice.Accounts

  def validate(account_id, _context) do
    case account_already_created?(account_id) do
      true -> {:error, "has already been created"}
      false -> :ok
    end
  end

  defp account_already_created?(account_id) do
    case Accounts.get_account(account_id) do
      {:error, _} -> false
      _ -> true
    end
  end
end
