defmodule DealogBackoffice.Accounts.Projections.Account do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: false}
  @timestamps_opts [type: :utc_datetime_usec]

  schema "accounts" do
    field :first_name, :string
    field :last_name, :string
    belongs_to :user, DealogBackoffice.Accounts.User

    timestamps()
  end
end
