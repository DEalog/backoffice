defmodule DealogBackoffice.Repo.Migrations.AddAuthorToApprovedMessagesProjection do
  use Ecto.Migration

  def change do
    alter table(:message_approvals) do
      add :author, :string
    end
  end
end
