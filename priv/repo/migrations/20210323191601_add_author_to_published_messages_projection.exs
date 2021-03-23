defmodule DealogBackoffice.Repo.Migrations.AddAuthorToPublishedMessagesProjection do
  use Ecto.Migration

  def change do
    alter table(:published_messages) do
      add :author, :string
    end
  end
end
