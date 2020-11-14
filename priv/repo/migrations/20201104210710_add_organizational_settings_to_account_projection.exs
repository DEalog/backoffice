defmodule DealogBackoffice.Repo.Migrations.AddOrganizationalSettingsToAccountProjection do
  use Ecto.Migration

  def change do
    alter table(:accounts) do
      add :administrative_area, :string
      add :organization, :string
      add :position, :string
    end
    create index(:accounts, [:administrative_area])
  end
end
