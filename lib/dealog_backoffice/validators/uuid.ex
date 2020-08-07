defmodule DealogBackoffice.Validators.UUID do
  use Vex.Validator

  def validate(value, _options) do
    Vex.Validators.By.validate(value,
      function: &is_valid_uuid?/1,
      allow_nil: false,
      allow_blank: false
    )
  end

  defp is_valid_uuid?(uuid) do
    case UUID.info(uuid) do
      {:ok, _} -> true
      {:error, _} -> false
    end
  end
end
