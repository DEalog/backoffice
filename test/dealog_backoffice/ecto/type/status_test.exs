defmodule DealogBackoffice.Ecto.Type.StatusTest do
  use ExUnit.Case, async: true

  import Ecto.Type

  alias DealogBackoffice.Ecto.Type.Status

  test "has correct type" do
    assert type(Status) == :string
  end

  test "casts the value if an atom" do
    assert cast(Status, :value) == {:ok, :value}
  end

  test "casts the value if a string" do
    assert cast(Status, "value") == {:ok, :value}
  end

  test "reports an error if the value is of an incompatible type" do
    assert cast(Status, 123) == :error
    assert cast(Status, %{}) == :error
  end

  test "loads a string to an atom" do
    assert load(Status, "value") == {:ok, :value}
  end

  test "dumps an atom to a string" do
    assert dump(Status, :value) == {:ok, "value"}
  end

  test "dumps a string" do
    assert dump(Status, "value") == {:ok, "value"}
  end
end
