defmodule DealogBackoffice.Accounts.Commands.CreateAccount do
  defstruct account_id: "",
            first_name: "",
            last_name: "",
            user_id: ""

  use ExConstructor
  use Vex.Struct

  alias DealogBackoffice.Accounts.Commands.CreateAccount
  alias DealogBackoffice.Accounts.Validators.{ExistingUserId, UniqueAccountId}

  validates(:account_id, uuid: true, by: &UniqueAccountId.validate/2)
  validates(:first_name, presence: [message: "can't be blank"], string: true)
  validates(:last_name, presence: [message: "can't be blank"], string: true)
  validates(:user_id, uuid: true, by: &ExistingUserId.validate/2)

  def assign_account_id(%CreateAccount{} = account, uuid) do
    %CreateAccount{account | account_id: uuid}
  end
end
