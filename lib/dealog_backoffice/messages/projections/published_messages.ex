defmodule DealogBackoffice.Messages.Projections.PublishedMessage do
  use Ecto.Schema

  alias DealogBackoffice.Ecto.Type.Status

  @primary_key {:id, :binary_id, autogenerate: false}
  @timestamps_opts [type: :utc_datetime_usec]

  schema "published_messages" do
    field :title, :string
    field :body, :string
    field :status, Status

    timestamps()
  end
end
