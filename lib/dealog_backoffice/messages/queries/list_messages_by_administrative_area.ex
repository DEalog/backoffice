defmodule DealogBackoffice.Messages.Queries.ListMessagesByAdministrativeArea do
  import Ecto.Query

  alias DealogBackoffice.Messages.Projections.Message

  @doc """
  Returns the list of messsages for an administrative area and the total counts

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
    from(m in Message, where: m.ars == ^ars, order_by: [desc: m.updated_at], preload: :changes)
  end

  defp count(query) do
    query |> select([:id])
  end
end
