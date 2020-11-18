defmodule DealogBackoffice.Repo.Migrations.AddCategoryToPublishedMessageProjection do
  use Ecto.Migration

  def change do
    alter table(:published_messages) do
      add :category, :string
    end
  end
end
