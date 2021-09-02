defmodule DealogBackoffice.Messages.Projections.ArchivedMessage do
  use Ecto.Schema

  alias DealogBackoffice.Ecto.Type.Status

  @primary_key {:id, :binary_id, autogenerate: false}
  @timestamps_opts [type: :utc_datetime_usec]

  schema "archived_messages" do
    field :title, :string
    field :body, :string
    field :category, :string
    field :ars, :string
    field :organization, :string
    field :status, Status

    timestamps()
  end
end
