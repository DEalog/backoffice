defmodule DealogBackoffice.Repo.Migrations.AddCategoryToDeletedMessageProjection do
  use Ecto.Migration

  def change do
    alter table(:deleted_messages) do
      add :category, :string
    end
  end
end
