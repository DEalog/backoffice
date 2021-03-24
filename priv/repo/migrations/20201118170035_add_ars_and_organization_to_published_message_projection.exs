defmodule DealogBackoffice.Repo.Migrations.AddArsAndOrganizationToPublishedMessageProjection do
  use Ecto.Migration

  def change do
    alter table(:published_messages) do
      add :ars, :string
      add :organization, :string
    end

    create index(:published_messages, [:ars])
  end
end
