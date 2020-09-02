defmodule DealogBackoffice.Messages.Projections.MessageForApproval do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: false}
  @timestamps_opts [type: :utc_datetime_usec]

  schema "message_approvals" do
    field :title, :string
    field :body, :string
    field :status, :string
    field :reason, :string
    field :note, :string

    timestamps()
  end
end
