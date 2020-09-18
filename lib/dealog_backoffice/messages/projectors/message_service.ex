defmodule DealogBackoffice.Messages.Projectors.MessageService do
  use Commanded.Event.Handler,
    application: DealogBackoffice.App,
    name: "Messages.Projectors.MessageService"

  @topic "messages"
  @worker_name :kafka_ex

  alias DealogBackoffice.Messages.Events.MessagePublished
  alias KafkaEx.Protocol.Produce.Message, as: KafkaMessage
  alias KafkaEx.Protocol.Produce.Request

  def handle(%MessagePublished{} = event, metadata) do
    ensure_connected()
    messages = build_messages(event, metadata)
    request = %Request{topic: @topic, api_version: 3, messages: messages}
    KafkaEx.produce(request)
  end

  defp ensure_connected do
    KafkaEx.create_worker(@worker_name)
  end

  defp build_messages(event, metadata), do: List.wrap(build_message(event, metadata))

  defp build_message(event, metadata) do
    payload =
      %{
        identifier: event.message_id,
        headline: event.title,
        description: event.body,
        geocode:
          "POLYGON ((11.795583 51.385388, 11.813135 51.398215, 11.827426 51.396073, 11.823821 51.391842, 11.795583 51.385388))",
        published_at: NaiveDateTime.to_iso8601(metadata.created_at)
      }
      |> Jason.encode!()

    %KafkaMessage{value: payload, timestamp: :os.system_time(:millisecond)}
  end
end
