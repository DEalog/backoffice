defmodule DealogBackoffice.Accounts.Validators.ExistingUserId do
  use Vex.Validator

  alias DealogBackoffice.Accounts

  def validate(user_id, _context) do
    case user_exists?(user_id) do
      false -> {:error, "does not exist"}
      true -> :ok
    end
  end

  defp user_exists?(user_id) when is_binary(user_id) do
    case Accounts.get_user(user_id) do
      {:ok, _} -> true
      _ -> false
    end
  end

  defp user_exists?(_), do: false
end
