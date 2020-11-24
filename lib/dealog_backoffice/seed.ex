defmodule DealogBackoffice.Seed do
  alias DealogBackoffice.Messages

  def messages(amount \\ 10) do
    Faker.start()

    for _ <- 0..amount do
      {:ok, message} =
        Messages.create_message(%{
          title: random_title(),
          body: random_body()
        })

      if should_transition?() do
        {:ok, message_for_approval} = Messages.send_message_for_approval(message)

        if should_transition?() do
          {:ok, message_to_approve} = Messages.get_message_for_approval(message_for_approval.id)
          {:ok, approved_message} = Messages.approve_message(message_to_approve)

          if should_transition?() do
            Messages.publish_message(approved_message)
          end
        end
      end
    end
  end

  def dev_user do
    user_data = %{
      email: "dev@dealog.de",
      password: "password1234"
    }

    DealogBackoffice.Importer.SuperUser.create(user_data)
  end

  defp random_title do
    Faker.Random.Elixir.random_between(2, 9)
    |> Faker.Lorem.sentence("")
  end

  defp random_body do
    2..5
    |> Faker.Lorem.paragraphs()
    |> Enum.join("\n")
  end

  defp should_transition? do
    Faker.Random.Elixir.random_between(0, 1) == 1
  end
end
