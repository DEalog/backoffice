defmodule DealogBackoffice.Accounts.Projections.Account do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: false}
  @timestamps_opts [type: :utc_datetime_usec]
  @foreign_key_type :binary_id

  schema "accounts" do
    field :first_name, :string
    field :last_name, :string
    field :administrative_area_id, :string
    field :organization, :string
    field :position, :string

    belongs_to :user, DealogBackoffice.Accounts.User

    has_one :administrative_area, DealogBackoffice.AdministrativeAreas.AdministrativeArea,
      foreign_key: :ars,
      references: :administrative_area_id

    timestamps()
  end
end
