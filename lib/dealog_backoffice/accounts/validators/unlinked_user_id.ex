defmodule DealogBackoffice.Accounts.Validators.UnlinkedUserId do
  use Vex.Validator

  alias DealogBackoffice.Accounts

  def validate(user_id, _context) do
    case has_already_an_account?(user_id) do
      true -> {:error, "already linked to an account"}
      false -> :ok
    end
  end

  defp has_already_an_account?(user_id) when is_binary(user_id) do
    case Accounts.get_account_by_user(user_id) do
      {:ok, _} -> true
      _ -> false
    end
  end

  defp has_already_an_account?(_), do: true
end
