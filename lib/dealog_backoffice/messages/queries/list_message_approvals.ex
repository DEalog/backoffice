defmodule DealogBackoffice.Messages.Queries.ListMessageApprovals do
  import Ecto.Query

  alias DealogBackoffice.Messages.Projections.MessageForApproval

  @doc """
  Returns the list of messsage approvals and the total counts

  {messages, count}
  """
  def paginate(repo) do
    query = query()
    messages = query |> repo.all()
    total_count = query |> count() |> repo.aggregate(:count, :id)
    {messages, total_count}
  end

  defp query do
    from(m in MessageForApproval, order_by: [desc: m.updated_at])
  end

  defp count(query) do
    query |> select([:id])
  end
end
