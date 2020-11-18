defmodule DealogBackoffice.Importer.SuperUser do
  def create(%{email: email, password: password}) do
    user_data = %{
      email: email,
      password: password
    }

    case DealogBackoffice.Accounts.register_user(user_data) do
      {:ok, user} ->
        confirm_user(user)

      {:error, error} ->
        {:error, error}
    end
  end

  defp confirm_user(user) do
    {encoded_token, user_token} =
      DealogBackoffice.Accounts.UserToken.build_email_token(user, "confirm")

    DealogBackoffice.Repo.insert!(user_token)
    DealogBackoffice.Accounts.confirm_user(encoded_token)
  end
end
