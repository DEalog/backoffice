defmodule DealogBackoffice.Messages.Projectors.MessageService do
  use Commanded.Event.Handler,
    application: DealogBackoffice.App,
    name: "Messages.Projectors.MessageService"

  @topic "messages"
  @worker_name :kafka_ex

  require Logger

  alias DealogBackoffice.Messages.Events.{MessagePublished, MessageUpdated, MessageArchived}
  alias KafkaEx.Protocol.Produce.Message, as: KafkaMessage
  alias KafkaEx.Protocol.Produce.Request

  def handle(%MessagePublished{} = event, metadata) do
    produce_and_send_message("Created", event, metadata)
  end

  def handle(%MessageUpdated{} = event, metadata) do
    produce_and_send_message("Updated", event, metadata)
  end

  def handle(%MessageArchived{} = event, metadata) do
    produce_and_send_message("Disposed", event, metadata)
  end

  defp produce_and_send_message(type, event, metadata) do
    ensure_connected()
    messages = build_messages(type, event, metadata)
    request = %Request{topic: @topic, api_version: 3, messages: messages}

    Logger.info(
      "Trying to publish message to topic #{@topic} [type: #{type}, id: #{event.message_id}]"
    )

    KafkaEx.produce(request)
  end

  defp ensure_connected do
    KafkaEx.create_worker(@worker_name)
  end

  defp build_messages(type, event, metadata), do: List.wrap(build_message(type, event, metadata))

  defp build_message(type, event, metadata) do
    payload =
      %{
        type: type,
        payload: %{
          identifier: event.message_id,
          headline: event.title,
          description: event.body,
          category: "Other",
          ars: get_in(metadata, ["organization", "administrative_area_id"]) || "000000000000",
          organization: get_in(metadata, ["organization", "organization"]) || "DEalog System",
          publishedAt: DateTime.to_unix(metadata.created_at, :millisecond)
        }
      }
      |> Jason.encode!()

    %KafkaMessage{value: payload, timestamp: :os.system_time(:millisecond)}
  end
end
