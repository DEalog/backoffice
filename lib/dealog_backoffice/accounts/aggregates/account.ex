defmodule DealogBackoffice.Accounts.Aggregates.Account do
  defstruct [
    :account_id,
    :first_name,
    :last_name,
    :user_id,
    :administrative_area,
    :organization,
    :position
  ]

  alias DealogBackoffice.Accounts.Aggregates.Account

  alias DealogBackoffice.Accounts.Commands.{
    CreateAccount,
    ChangePersonalData,
    ChangeOrganizationalSettings
  }

  alias DealogBackoffice.Accounts.Events.{
    AccountCreated,
    PersonalDataChanged,
    OrganizationalSettingsChanged
  }

  def execute(%Account{}, %CreateAccount{user_id: ""}), do: {:error, :missing_user_id}

  def execute(%Account{account_id: nil}, %CreateAccount{} = create) do
    %AccountCreated{
      account_id: create.account_id,
      first_name: create.first_name,
      last_name: create.last_name,
      user_id: create.user_id,
      administrative_area: create.administrative_area,
      organization: create.organization,
      position: create.position
    }
  end

  def execute(%Account{account_id: account_id}, %ChangePersonalData{} = change_personal_data) do
    %PersonalDataChanged{
      account_id: account_id,
      first_name: change_personal_data.first_name,
      last_name: change_personal_data.last_name
    }
  end

  def execute(
        %Account{account_id: account_id},
        %ChangeOrganizationalSettings{} = change_organizational_settings
      ) do
    %OrganizationalSettingsChanged{
      account_id: account_id,
      administrative_area: change_organizational_settings.administrative_area,
      organization: change_organizational_settings.organization,
      position: change_organizational_settings.position
    }
  end

  def apply(%Account{} = account, %AccountCreated{} = created) do
    %Account{
      account
      | account_id: created.account_id,
        first_name: created.first_name,
        last_name: created.last_name,
        user_id: created.user_id
    }
  end

  def apply(%Account{} = account, %PersonalDataChanged{} = personal_data_changed) do
    %Account{
      account
      | first_name: personal_data_changed.first_name,
        last_name: personal_data_changed.last_name
    }
  end

  def apply(%Account{} = account, %OrganizationalSettingsChanged{} = organizational_data_changed) do
    %Account{
      account
      | administrative_area: organizational_data_changed.administrative_area,
        organization: organizational_data_changed.organization,
        position: organizational_data_changed.position
    }
  end
end
