defmodule DealogBackoffice.Repo.Migrations.CreatePublishedMessagesProjection do
  use Ecto.Migration

  def change do
    create table(:published_messages, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :title, :string
      add :body, :text
      add :status, :string

      timestamps()
    end
  end
end
