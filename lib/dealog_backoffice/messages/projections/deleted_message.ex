defmodule DealogBackoffice.Messages.Projections.DeletedMessage do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: false}
  @timestamps_opts [type: :utc_datetime_usec]

  schema "deleted_messages" do
    field :title, :string
    field :body, :string
    field :status, :string

    timestamps()
  end
end
