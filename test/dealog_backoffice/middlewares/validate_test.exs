defmodule DealogBackoffice.Middlewares.ValidateTest do
  use ExUnit.Case

  alias Commanded.Middleware.Pipeline
  alias DealogBackoffice.Middlewares.Validate
  alias DealogBackoffice.TestCommand

  describe "before command dispatch" do
    test "should reject command with validation errors" do
      assert %{
               halted: true,
               command: %TestCommand{},
               response: {:error, {:validation_failure, _}}
             } = execute_before_dispatch(title: "", body: "")
    end

    test "should not reject command with valid data" do
      assert %{
               halted: false,
               command: %TestCommand{},
               response: nil
             } = execute_before_dispatch(title: "A valid title", body: "A valid body")
    end

    test "should list the validation errors" do
      assert %{
               halted: true,
               command: %TestCommand{},
               response: {:error, {:validation_failure, %{body: ["invalid"], title: ["empty"]}}}
             } = execute_before_dispatch(title: "", body: 1)
    end
  end

  defp execute_before_dispatch(title: title, body: body) do
    %Pipeline{
      causation_id: UUID.uuid4(),
      correlation_id: UUID.uuid4(),
      command: %TestCommand{
        title: title,
        body: body
      },
      command_uuid: UUID.uuid4(),
      metadata: %{}
    }
    |> Validate.before_dispatch()
  end
end
