defmodule DealogBackoffice.Repo.Migrations.AddCategoryToMessageProjection do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      add :category, :string
    end
  end
end
