defmodule DealogBackoffice.Repo.Migrations.ChangeAdministrativeAreas do
  use Ecto.Migration

  def change do
    rename table(:administrative_areas), :ags, to: :ars
    rename table(:administrative_areas), :parent_ags, to: :parent_ars
    rename table(:administrative_areas), :inserted_at, to: :imported_at

    alter table(:administrative_areas) do
      remove :updated_at
    end
  end
end
