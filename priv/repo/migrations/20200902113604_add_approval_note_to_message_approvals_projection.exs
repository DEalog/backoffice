defmodule DealogBackoffice.Repo.Migrations.AddApprovalNoteToMessageApprovalsProjection do
  use Ecto.Migration

  def change do
    alter table(:message_approvals) do
      add :note, :text
    end
  end
end
