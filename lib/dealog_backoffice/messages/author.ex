defmodule DealogBackoffice.Messages.Author do
  @derive Jason.Encoder
  defstruct [
    :id,
    :first_name,
    :last_name,
    :email,
    :position,
    :organization,
    :administrative_area_id
  ]
end
