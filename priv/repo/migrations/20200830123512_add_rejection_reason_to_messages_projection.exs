defmodule DealogBackoffice.Repo.Migrations.AddRejectionReasonToMessagesProjection do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      add :rejection_reason, :text
    end
  end
end
