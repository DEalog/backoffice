defmodule DealogBackoffice.Repo.Migrations.AddReasonToMessageApprovalsProjection do
  use Ecto.Migration

  def change do
    alter table(:message_approvals) do
      add :reason, :text
    end
  end
end
