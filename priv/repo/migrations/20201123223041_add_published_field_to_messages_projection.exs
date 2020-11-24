defmodule DealogBackoffice.Repo.Migrations.AddPublishedFieldToMessagesProjection do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      add :published, :boolean, default: false
    end
  end
end
