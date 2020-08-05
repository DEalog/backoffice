defmodule DealogBackoffice.Repo.Migrations.CreateMessagesProjection do
  use Ecto.Migration

  def change do
    create table(:messages, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :title, :string
      add :body, :text

      timestamps()
    end
  end
end
