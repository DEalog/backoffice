defmodule DealogBackoffice.Repo.Migrations.AddAdministrativeAreaAssociationToAccountProjection do
  use Ecto.Migration

  def change do
    rename table(:accounts), :administrative_area, to: :administrative_area_id
  end
end
