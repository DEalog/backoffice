defmodule DealogBackoffice.Messages.Queries.ListMessages do
  import Ecto.Query

  alias DealogBackoffice.Messages.Projections.Message

  def paginate(repo) do
    query = query()
    messages = query |> repo.all()
    total_count = query |> count() |> repo.aggregate(:count, :id)
    {messages, total_count}
  end

  defp query do
    from(m in Message, order_by: [desc: m.updated_at])
  end

  defp count(query) do
    query |> select([:id])
  end
end
