defmodule DealogBackoffice.Accounts.Commands.CreateAccount do
  defstruct account_id: "",
            first_name: "",
            last_name: "",
            user_id: "",
            administrative_area: "",
            organization: "",
            position: ""

  use ExConstructor
  use Vex.Struct

  alias DealogBackoffice.Accounts.Commands.CreateAccount

  validates(:account_id, uuid: true, unique_account_id: true)
  validates(:first_name, presence: [message: "can't be blank"], string: true)
  validates(:last_name, presence: [message: "can't be blank"], string: true)
  validates(:user_id, uuid: true, existing_user_id: true, unlinked_user_id: true)
  validates(:administrative_area, presence: [message: "one has to be chosen"], string: true)
  validates(:organization, string: true)
  validates(:position, string: true)

  def assign_account_id(%CreateAccount{} = account, uuid) do
    %CreateAccount{account | account_id: uuid}
  end
end
