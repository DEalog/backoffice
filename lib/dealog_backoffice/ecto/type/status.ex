defmodule DealogBackoffice.Ecto.Type.Status do
  use Ecto.Type

  def type(), do: :string

  def cast(status) when is_atom(status), do: {:ok, status}
  def cast(status) when is_binary(status), do: {:ok, String.to_existing_atom(status)}
  def cast(_), do: :error

  def load(data) when is_binary(data) do
    {:ok, String.to_existing_atom(data)}
  end

  def dump(status) when is_atom(status), do: {:ok, Atom.to_string(status)}
  def dump(status) when is_binary(status), do: {:ok, status}
  def dump(_), do: :error
end
