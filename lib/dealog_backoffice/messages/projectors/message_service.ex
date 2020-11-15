defmodule DealogBackoffice.Messages.Projectors.MessageService do
  use Commanded.Event.Handler,
    application: DealogBackoffice.App,
    name: "Messages.Projectors.MessageService"

  @topic "messages"
  @worker_name :kafka_ex

  alias DealogBackoffice.Messages.Events.{MessagePublished, MessageUpdated}
  alias KafkaEx.Protocol.Produce.Message, as: KafkaMessage
  alias KafkaEx.Protocol.Produce.Request

  def handle(%MessagePublished{} = event, metadata) do
    produce_and_send_message("Created", event, metadata)
  end

  def handle(%MessageUpdated{} = event, metadata) do
    produce_and_send_message("Updated", event, metadata)
  end

  defp produce_and_send_message(type, event, metadata) do
    ensure_connected()
    messages = build_messages(type, event, metadata)
    request = %Request{topic: @topic, api_version: 3, messages: messages}
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
          ars: "059580004004",
          published_at: NaiveDateTime.to_iso8601(metadata.created_at)
        }
      }
      |> Jason.encode!()

    %KafkaMessage{value: payload, timestamp: :os.system_time(:millisecond)}
  end
end
