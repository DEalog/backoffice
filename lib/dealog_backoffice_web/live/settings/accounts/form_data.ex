defmodule DealogBackofficeWeb.SettingsLive.Accounts.FormData do
  use Ecto.Schema

  import Ecto.Changeset

  alias DealogBackoffice.Accounts.Projections.Account
  alias DealogBackofficeWeb.SettingsLive.Accounts.FormData

  @required_fields [
    :first_name,
    :last_name,
    :user_id,
    :administrative_area_id
  ]
  @optional_fields [
    :organization,
    :position
  ]
  @primary_key {:id, :binary_id, autogenerate: false}

  schema "form_data" do
    field :first_name, :string
    field :last_name, :string
    field :user_id, :binary_id
    field :administrative_area_id, :string
    field :administrative_area, :string
    field :organization, :string
    field :position, :string
  end

  def load_from_account(%Account{} = account) do
    FormData
    |> struct(Map.from_struct(account))
  end

  def changeset_for_account(schema, account_params \\ %{}) do
    schema
    |> cast(account_params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> set_administrative_area()
  end

  defp set_administrative_area(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{administrative_area_id: administrative_area_id}} ->
        put_change(changeset, :administrative_area, administrative_area_id)

      _ ->
        changeset
    end
  end
end
