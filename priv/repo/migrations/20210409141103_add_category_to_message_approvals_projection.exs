defmodule DealogBackoffice.Repo.Migrations.AddCategoryToMessageApprovalsProjection do
  use Ecto.Migration

  def change do
    alter table(:message_approvals) do
      add :category, :string
    end
  end
end
