defmodule DealogBackoffice.Repo.Migrations.AddAuthorToMessagesProjection do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      add :author, :string
    end
  end
end
