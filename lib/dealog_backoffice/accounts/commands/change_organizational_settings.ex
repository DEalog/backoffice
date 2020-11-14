defmodule DealogBackoffice.Accounts.Commands.ChangeOrganizationalSettings do
  defstruct account_id: "",
            administrative_area: "",
            organization: "",
            position: ""

  use ExConstructor
  use Vex.Struct

  alias DealogBackoffice.Accounts.Commands.ChangeOrganizationalSettings

  validates(:account_id, uuid: true)
  validates(:administrative_area, presence: [message: "one has to be chosen"], string: true)
  validates(:organization, presence: [message: "can't be blank"], string: true)

  def assign_account_id(change_organizational_settings, id) do
    %ChangeOrganizationalSettings{
      change_organizational_settings
      | account_id: id
    }
  end
end
