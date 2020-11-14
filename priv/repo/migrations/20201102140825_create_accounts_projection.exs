defmodule DealogBackoffice.Repo.Migrations.CreateAccountsProjection do
  use Ecto.Migration

  def change do
    create table(:accounts, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :first_name, :string
      add :last_name, :string

      timestamps()
    end
  end
end
