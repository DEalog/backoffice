defmodule DealogBackoffice.Messages.Projections.Message do
  use Ecto.Schema

  alias DealogBackoffice.Ecto.Type.Status

  alias DealogBackoffice.Messages.Projections.MessageChange

  @primary_key {:id, :binary_id, autogenerate: false}
  @timestamps_opts [type: :utc_datetime_usec]

  schema "messages" do
    field :title, :string
    field :body, :string
    field :category, :string
    field :status, Status
    field :rejection_reason, :string
    field :published, :boolean
    field :author

    has_many :changes, MessageChange

    timestamps()
  end
end
