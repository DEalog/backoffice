defmodule DealogBackoffice.Repo.Migrations.CreateMessageApprovalProjection do
  use Ecto.Migration

  def change do
    create table(:message_approvals, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :title, :string
      add :body, :text
      add :status, :string

      timestamps()
    end
  end
end
