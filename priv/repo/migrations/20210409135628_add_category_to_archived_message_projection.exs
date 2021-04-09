defmodule DealogBackoffice.Repo.Migrations.AddCategoryToArchivedMessageProjection do
  use Ecto.Migration

  def change do
    alter table(:archived_messages) do
      add :category, :string
    end
  end
end
