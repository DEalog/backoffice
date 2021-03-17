defmodule DealogBackoffice.MessageTestHelpers do
  alias DealogBackoffice.Accounts.User
  alias DealogBackoffice.Accounts.Projections.Account

  def build_user do
    %User{
      email: "an@email.test",
      account: %Account{
        first_name: "John",
        last_name: "Doe",
        position: "The position",
        organization: "The organization",
        administrative_area_id: "1234"
      }
    }
  end
end
