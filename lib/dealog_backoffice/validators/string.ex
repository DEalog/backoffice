defmodule DealogBackoffice.Validators.String do
  @moduledoc """
  Ensure a value is a valid string.

  ## Options

  No mandatory options.

  Optional:

  * `:message`: A custom error message. May be in EEx format
    and use the fields described in [Custom Error Messages](#module-custom-error-messages).

  ## Examples

  iex> DealogBackoffice.Validators.String.validate("a string", [])
  :ok

  iex> DealogBackoffice.Validators.String.validate(1, [])
  {:error, "must be a string"}

  iex> DealogBackoffice.Validators.String.validate(1, [message: "custom message"])
  {:error, "custom message"}
  """
  use Vex.Validator

  @impl true
  def validate(nil, _options), do: :ok
  def validate("", _options), do: :ok

  def validate(value, options) do
    Vex.Validators.By.validate(
      value,
      [function: &String.valid?/1] ++ options ++ [message: "must be a string"]
    )
  end
end
