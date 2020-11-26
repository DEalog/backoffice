defmodule DealogBackoffice.Seed do
  alias DealogBackoffice.Messages

  @drafted_amount 7
  @sent_for_approval_amount 5
  @approved_amount 6
  @published_amount 10

  def messages do
    Faker.start()

    drafted = Task.async(&create_drafted/0)
    sent_for_approval = Task.async(&create_sent_for_approval/0)
    approved = Task.async(&create_approved/0)
    published = Task.async(&create_published/0)
    Task.await(drafted, :infinity)
    Task.await(sent_for_approval, :infinity)
    Task.await(approved, :infinity)
    Task.await(published, :infinity)
  end

  defp create_drafted do
    for _ <- 0..@drafted_amount do
      {:ok, _} =
        Messages.create_message(%{
          title: random_title(),
          body: random_body()
        })
    end
  end

  defp create_sent_for_approval do
    for _ <- 0..@sent_for_approval_amount do
      {:ok, message} =
        Messages.create_message(%{
          title: random_title(),
          body: random_body()
        })

      {:ok, _} = Messages.send_message_for_approval(message)
    end
  end

  defp create_approved do
    for _ <- 0..@approved_amount do
      {:ok, message} =
        Messages.create_message(%{
          title: random_title(),
          body: random_body()
        })

      {:ok, message_for_approval} = Messages.send_message_for_approval(message)
      {:ok, message_to_approve} = Messages.get_message_for_approval(message_for_approval.id)
      {:ok, _} = Messages.approve_message(message_to_approve)
    end
  end

  defp create_published do
    for _ <- 0..@published_amount do
      {:ok, message} =
        Messages.create_message(%{
          title: random_title(),
          body: random_body()
        })

      {:ok, message_for_approval} = Messages.send_message_for_approval(message)
      {:ok, message_to_approve} = Messages.get_message_for_approval(message_for_approval.id)
      {:ok, approved_message} = Messages.approve_message(message_to_approve)
      {:ok, _} = Messages.publish_message(approved_message)
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
end
