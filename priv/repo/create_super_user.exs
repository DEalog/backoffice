alias DealogBackoffice.Importer.SuperUser

length = 12

user_data = %{
  email: "super_user@dealog.de",
  password: :crypto.strong_rand_bytes(length) |> Base.encode64() |> binary_part(0, length)
}

case SuperUser.create(user_data) do
  {:ok, _} ->
    IO.puts(
      "Super user created successfully. Please use #{user_data.email} and #{user_data.password}"
    )

  {:error, %{errors: [email: {"has already been taken", _}]}} ->
    IO.puts("There is already a super user available.")
end
