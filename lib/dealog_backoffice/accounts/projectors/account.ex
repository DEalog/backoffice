defmodule DealogBackoffice.Accounts.Projectors.Account do
  use Commanded.Projections.Ecto,
    application: DealogBackoffice.App,
    name: "Accounts.Projectors.Account",
    consistency: :strong

  alias DealogBackoffice.Accounts.Events.{
    AccountCreated,
    PersonalDataChanged,
    OrganizationalSettingsChanged
  }

  alias DealogBackoffice.Accounts.Projections.Account

  project(%AccountCreated{} = created, metadata, fn multi ->
    Ecto.Multi.insert(
      multi,
      :account,
      %Account{
        id: created.account_id,
        first_name: created.first_name,
        last_name: created.last_name,
        user_id: created.user_id,
        administrative_area: created.administrative_area,
        organization: created.organization,
        position: created.position,
        inserted_at: metadata.created_at
      }
    )
  end)

  project(%PersonalDataChanged{} = changed_personal_data, metadata, fn multi ->
    update_account(multi, changed_personal_data.account_id,
      first_name: changed_personal_data.first_name,
      last_name: changed_personal_data.last_name,
      updated_at: metadata.created_at
    )
  end)

  project(
    %OrganizationalSettingsChanged{} = changed_organizational_settings,
    metadata,
    fn multi ->
      update_account(multi, changed_organizational_settings.account_id,
        administrative_area: changed_organizational_settings.administrative_area,
        organization: changed_organizational_settings.organization,
        position: changed_organizational_settings.position,
        updated_at: metadata.created_at
      )
    end
  )

  defp update_account(multi, account_id, changes) do
    Ecto.Multi.update_all(multi, :account, query(account_id), set: changes)
  end

  defp query(account_id) do
    from(a in Account, where: a.id == ^account_id)
  end
end
