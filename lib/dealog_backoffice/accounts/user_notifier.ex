defmodule DealogBackoffice.Accounts.UserNotifier do
  import Swoosh.Email
  import DealogBackoffice.Gettext

  defp deliver(to, subject, body) do
    require Logger
    Logger.debug(body)

    new()
    |> to(to)
    |> from({"DEalog System", "system@dealog.de"})
    |> subject(subject)
    |> text_body(body)
    |> DealogBackoffice.Accounts.Mailer.deliver()

    {:ok, %{to: to, body: body}}
  end

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(user, url) do
    deliver(
      user.email,
      gettext("Confirm your DEalog account"),
      gettext(
        """
        Hi %{email},

        you can confirm your account by visiting the URL below:

        %{url}

        If you didn't create an account, please ignore this.
        """,
        email: user.email,
        url: url
      )
    )
  end

  @doc """
  Deliver instructions to reset a user password.
  """
  def deliver_reset_password_instructions(user, url) do
    deliver(
      user.email,
      gettext("Reset your DEalog password"),
      gettext(
        """
        Hi %{email},

        you can reset your password by visiting the URL below:

        %{url}

        If you didn't request this change, please ignore this.
        """,
        email: user.email,
        url: url
      )
    )
  end

  @doc """
  Deliver instructions to update a user email.
  """
  def deliver_update_email_instructions(user, url) do
    deliver(
      user.email,
      gettext("Update your DEalog email address"),
      gettext(
        """
        Hi %{email},

        you can change your email address by visiting the URL below:

        %{url}

        If you didn't request this change, please ignore this.
        """,
        email: user.email,
        url: url
      )
    )
  end
end
