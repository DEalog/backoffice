defmodule DealogBackoffice.Repo.Migrations.AddArsAndOrganizationToProjections do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      add :ars, :string
      add :organization, :string
    end

    create index(:messages, [:ars])

    alter table(:message_approvals) do
      add :ars, :string
      add :organization, :string
    end

    create index(:message_approvals, [:ars])

    alter table(:archived_messages) do
      add :ars, :string
      add :organization, :string
    end

    create index(:archived_messages, [:ars])

    alter table(:deleted_messages) do
      add :ars, :string
      add :organization, :string
    end

    create index(:deleted_messages, [:ars])
  end
end
