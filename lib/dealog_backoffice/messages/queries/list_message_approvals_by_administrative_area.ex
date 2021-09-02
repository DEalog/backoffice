defmodule DealogBackoffice.Messages.Queries.ListMessageApprovalsByAdministrativeArea do
  import Ecto.Query

  alias DealogBackoffice.Messages.Projections.MessageForApproval

  @doc """
  Returns the list of messsage approvals and the total counts

  {messages, count}
  """
  def paginate(_repo, nil), do: {[], 0}

  def paginate(repo, ars) do
    query = query(ars)
    messages = query |> repo.all()
    total_count = query |> count() |> repo.aggregate(:count, :id)
    {messages, total_count}
  end

  defp query(ars) do
    from(m in MessageForApproval, where: m.ars == ^ars, order_by: [desc: m.updated_at])
  end

  defp count(query) do
    query |> select([:id])
  end
end
