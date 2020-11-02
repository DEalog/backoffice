defmodule DealogBackoffice.Repo.Migrations.CreateAdministrativeAreas do
  use Ecto.Migration

  def change do
    create table(:administrative_areas, primary_key: false) do
      add :ags, :string, primary_key: true
      add :parent_ags, :string
      add :name, :string
      add :type_label, :string
      add :type, :string

      timestamps()
    end
  end
end
