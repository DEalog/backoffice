defmodule DealogBackoffice.Middlewares.Log do
  @moduledoc """
  Middleware logging all events happening.
  """
  @behaviour Commanded.Middleware

  require Logger

  alias Commanded.Middleware.Pipeline

  @impl true
  def before_dispatch(%Pipeline{} = pipeline) do
    log_command("Command is dispatching", pipeline)
    pipeline
  end

  @impl true
  def after_dispatch(%Pipeline{} = pipeline) do
    log_command("Command was dispatched", pipeline)
    pipeline
  end

  @impl true
  def after_failure(%Pipeline{} = pipeline) do
    log_command("Command failed", pipeline)
    pipeline
  end

  defp log_command(message, %Pipeline{} = pipeline) do
    Logger.info(
      "#{message} [type: #{pipeline.command.__struct__}, command_id: #{pipeline.command_uuid}]"
    )
  end
end
