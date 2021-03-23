defmodule DealogBackoffice.Messages.Projections.PublishedMessage do
  use Ecto.Schema

  alias DealogBackoffice.Ecto.Type.Status

  alias DealogBackoffice.Messages.Projections.MessageChange

  @primary_key {:id, :binary_id, autogenerate: false}
  @timestamps_opts [type: :utc_datetime_usec]

  schema "published_messages" do
    field :title, :string
    field :body, :string
    field :category, :string
    field :ars, :string
    field :organization, :string
    field :status, Status

    has_many :changes, MessageChange, foreign_key: :message_id

    timestamps()
  end
end
