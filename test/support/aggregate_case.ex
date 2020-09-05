defmodule DealogBackoffice.AggregateCase do
  @moduledoc """
  Test case for asserting aggregates.
  """

  use ExUnit.CaseTemplate

  using aggregate: aggregate do
    quote bind_quoted: [aggregate: aggregate] do
      @aggregate_module aggregate

      # Assert that expected events are returned by commands.
      defp assert_events(commands, expected_events) do
        assert_events([], commands, expected_events)
      end

      defp assert_events(initial_events, commands, expected_events) do
        {_aggregate, events, error} =
          %@aggregate_module{}
          |> evolve(initial_events)
          |> execute(commands)

        actual_events = List.wrap(events)

        assert is_nil(error), "An unexpected error did occur: #{inspect(error)}"
        assert expected_events == actual_events
      end

      defp assert_error(commands, expected_error) do
        assert_error([], commands, expected_error)
      end

      defp assert_error(initial_events, commands, expected_error) do
        {_aggregate, events, error} =
          %@aggregate_module{}
          |> evolve(initial_events)
          |> execute(commands)

        assert error == expected_error, "Expected error did not occur"
      end

      # Apply one or more events to an aggregate
      defp evolve(aggregate, events) do
        events
        |> List.wrap()
        |> Enum.reduce(aggregate, &@aggregate_module.apply(&2, &1))
      end

      defp execute(aggregate, commands) do
        commands
        |> List.wrap()
        |> Enum.reduce({aggregate, [], nil}, fn
          command, {aggregate, _events, nil} ->
            case @aggregate_module.execute(aggregate, command) do
              {:error, reason} = error -> {aggregate, nil, error}
              events -> {evolve(aggregate, events), events, nil}
            end

          _command, {aggregate, _events, _error} = reply ->
            reply
        end)
      end
    end
  end
end
