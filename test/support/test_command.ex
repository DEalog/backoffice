defmodule DealogBackoffice.TestCommand do
  defstruct [:title, :body]

  use Vex.Struct

  validates(:title, presence: [message: "empty"])
  validates(:body, string: [message: "invalid"])
end
