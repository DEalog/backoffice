defmodule DealogBackoffice.Repo.Migrations.AddLinkBetweenUserAndAccount do
  use Ecto.Migration

  def change do
    alter table(:accounts) do
      add :user_id, references(:users, type: :binary_id, on_delete: :nilify_all), null: true
    end

    create unique_index(:accounts, [:user_id])
  end
end
