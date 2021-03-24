defmodule DealogBackoffice.Repo.Migrations.CreateMessageHistoryProjection do
  use Ecto.Migration

  def change do
    create table(:messages_history, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :action, :string
      add :author, :jsonb, default: "[]"
      add :organization, :jsonb, default: "[]"

      add :message_id, :uuid

      timestamps(updated_at: false)
    end
  end
end
