defmodule DealogBackoffice.Accounts.Commands.ChangePersonalData do
  defstruct account_id: "",
            first_name: "",
            last_name: ""

  use ExConstructor
  use Vex.Struct

  alias DealogBackoffice.Accounts.Commands.ChangePersonalData

  validates(:account_id, uuid: true)
  validates(:first_name, presence: [message: "can't be blank"], string: true)
  validates(:last_name, presence: [message: "can't be blank"], string: true)

  def assign_account_id(change_personal_data, id) do
    %ChangePersonalData{
      change_personal_data
      | account_id: id
    }
  end
end
