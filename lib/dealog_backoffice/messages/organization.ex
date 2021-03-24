defmodule DealogBackoffice.Messages.Organization do
  @derive Jason.Encoder
  defstruct [
    :id,
    :name,
    :administrative_area_id
  ]
end
