defmodule DealogBackoffice.Messages.Projections.MessageForApproval do
  use Ecto.Schema

  alias DealogBackoffice.Ecto.Type.Status

  alias DealogBackoffice.Messages.Projections.MessageChange

  @primary_key {:id, :binary_id, autogenerate: false}
  @timestamps_opts [type: :utc_datetime_usec]

  schema "message_approvals" do
    field :title, :string
    field :body, :string
    field :status, Status
    field :reason, :string
    field :note, :string
    field :author, :string

    has_many :changes, MessageChange, foreign_key: :message_id

    timestamps()
  end
end
