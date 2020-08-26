defmodule DealogBackoffice.Messages.Validators.UniqueMessageId do
  use Vex.Validator

  alias DealogBackoffice.Messages

  def validate(message_id, _context) do
    case message_already_created?(message_id) do
      true -> {:error, "has already been created"}
      false -> :ok
    end
  end

  defp message_already_created?(message_id) do
    case Messages.get_message(message_id) do
      {:error, _} -> false
      _ -> true
    end
  end
end
