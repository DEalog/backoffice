defmodule DealogBackoffice.Messages.Projections.MessageChange do
  use Ecto.Schema

  alias DealogBackoffice.Messages.Projections.Message

  @primary_key {:id, :binary_id, autogenerate: false}
  @timestamps_opts [type: :utc_datetime_usec]

  schema "messages_history" do
    field :action, :string

    embeds_one :author, __MODULE__.Author
    embeds_one :organization, __MODULE__.Organization

    belongs_to :message, Message, type: :binary_id

    timestamps(updated_at: false)
  end

  defmodule Author do
    use Ecto.Schema

    @primary_key false
    embedded_schema do
      field :id, :binary_id
      field :name, :string
      field :email, :string
      field :position, :string
    end
  end

  defmodule Organization do
    use Ecto.Schema

    @primary_key false
    embedded_schema do
      field :name, :string
      field :administrative_area_id, :string
    end
  end
end
