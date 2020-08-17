defmodule DealogBackoffice.Middlewares.Validate do
  @moduledoc """
  A `Commanded.Middleware` that runs the defined validations on each command 
  before dispatch.
  """
  @behaviour Commanded.Middleware

  alias Commanded.Middleware.Pipeline

  import Pipeline

  @impl true
  def before_dispatch(%Pipeline{command: command} = pipeline) do
    case Vex.valid?(command) do
      true -> pipeline
      false -> failed_validation(pipeline)
    end
  end

  @impl true
  def after_dispatch(pipeline), do: pipeline

  @impl true
  def after_failure(pipeline), do: pipeline

  defp failed_validation(%Pipeline{command: command} = pipeline) do
    errors =
      command
      |> Vex.errors()
      |> merge_errors()

    pipeline
    |> respond({:error, {:validation_failure, errors}})
    |> halt()
  end

  defp merge_errors(errors) do
    errors
    |> Enum.group_by(
      fn {_error, field, _type, _message} -> field end,
      fn {_error, _field, _type, message} -> message end
    )
    |> Map.new()
  end
end
